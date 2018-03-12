// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Swift.Writer;
using System;
using System.Collections.Generic;
using System.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swift.Model
{
    /// <summary>
    /// Defines a synthesized composite type that wraps a primary type, array, or dictionary method response.
    /// </summary>
    public class CompositeTypeSwift : CompositeType, IVariableType
    {
        public static string TestNamespace { get; set; }

        private bool _wrapper;

        // True if the type is returned by a method
        public bool IsResponseType;

        // Name of the field containing the URL used to retrieve the next result set
        // (null or empty if the model is not paged).
        public string NextLink;

        public bool PreparerNeeded = false;

        public bool HasCodingKeys { get; set; }

        internal CompositeFieldWriter FieldWriter { get; private set; }

        public IEnumerable<CompositeType> DerivedTypes => CodeModel.ModelTypes.Where(t => t.DerivesFrom(this));

        public IEnumerable<CompositeType> SiblingTypes
        {
            get
            {
                var st = (BaseModelType as CompositeTypeSwift).DerivedTypes;
                if (BaseModelType.BaseModelType != null && BaseModelType.BaseModelType.IsPolymorphic)
                {
                    st = st.Union((BaseModelType as CompositeTypeSwift).SiblingTypes);
                }
                return st;
            }
        }

        public string InterfaceOutput
        {
            get
            {
                CompositeTypeSwift baseType = (CompositeTypeSwift)this.BaseModelType;
                if(baseType != null)
                {
                    return $"{this.Name}Protocol, {baseType.InterfaceOutput}";
                }

                return $"{this.Name}Protocol";
            }
        }

        public string BaseTypeInterfaceForProtocol
        {
            get
            {
                CompositeTypeSwift baseType = (CompositeTypeSwift)this.BaseModelType;
                if(baseType != null)
                {
                    return $"{baseType.Name}Protocol";
                }

                return $"Codable";
            }
        }

        public bool HasPolymorphicFields
        {
            get
            {
                return AllProperties.Any(p => 
                        // polymorphic composite
                        (p.ModelType is CompositeType && (p.ModelType as CompositeTypeSwift).IsPolymorphic) ||
                        // polymorphic array
                        (p.ModelType is SequenceType && (p.ModelType as ArrayTypeSwift).ElementType is CompositeType &&
                            ((p.ModelType as ArrayTypeSwift).ElementType as CompositeType).IsPolymorphic));
            }
        }

        public EnumType DiscriminatorEnum;

        public string DiscriminatorEnumValue => (DiscriminatorEnum as EnumTypeSwift).Constants.FirstOrDefault(c => c.Value.Equals(SerializedName)).Key;

        public CompositeTypeSwift()
        {
            this.FieldWriter = new CompositeFieldWriter(this);
        }

        public CompositeTypeSwift(string name) : base(name)
        {
            this.FieldWriter = new CompositeFieldWriter(this);
        }

        /// <summary>
        /// If PolymorphicDiscriminator is set, makes sure we have a PolymorphicDiscriminator property.
        /// </summary>
        public void AddPolymorphicPropertyIfNecessary()
        {
            if (!string.IsNullOrEmpty(PolymorphicDiscriminator) && Properties.All(p => p.SerializedName != PolymorphicDiscriminator))
            {
                base.Add(New<Property>(new
                {
                    Name = CodeNamerSwift.Instance.GetPropertyName(PolymorphicDiscriminator),
                    SerializedName = PolymorphicDiscriminator,
                    ModelType = DiscriminatorEnum,
                }));
            }            
        }

        public string PolymorphicProperty
        {
            get
            {
                if (!string.IsNullOrEmpty(PolymorphicDiscriminator))
                {
                    return CodeNamerSwift.Instance.GetPropertyName(PolymorphicDiscriminator);
                }
                if (BaseModelType != null)
                {
                    return (BaseModelType as CompositeTypeSwift).PolymorphicProperty;
                }
                return null;
            }
        }

        public IEnumerable<PropertySwift> AllProperties
        {
            get
            {
                if (BaseModelType != null)
                {
                    return Properties.Cast<PropertySwift>().Concat((BaseModelType as CompositeTypeSwift).AllProperties);
                }
                return Properties.Cast<PropertySwift>();
            }
        }

        public override Property Add(Property item)
        {
            var property = base.Add(item) as PropertySwift;
            return property;
        }

        /// <summary>
        /// Add imports for composite types.
        /// </summary>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            Properties.ForEach(p => p.ModelType.AddImports(imports));
        }

        public bool IsPolymorphicResponse() {
            if (BaseIsPolymorphic && BaseModelType != null)
            {
                return (BaseModelType as CompositeTypeSwift).IsPolymorphicResponse();
            }
            return IsPolymorphic && IsResponseType;
        }

        public IModelType BaseType { get; private set; }

        public IModelType GetElementType(IModelType type)
        {
            if (type is ArrayTypeSwift)
            {
                Name += "List";
                return GetElementType((type as SequenceType).ElementType);
            }
            else if (type is DictionaryTypeSwift)
            {
                Name += "Set";
                return GetElementType(((type as DictionaryTypeSwift).ValueType));
            }
            else
            {
                return type;
            }
        }

        public void SetName(string name)
        {
            Name = name;
        }

        public bool IsRequired { get; set; }

        public string VariableTypeDeclaration(bool isRequired)
        {
            return SwiftNameHelper.getTypeName(this.Name + "Protocol", isRequired);
        }

        public string EncodeTypeDeclaration(bool isRequired)
        {
                return SwiftNameHelper.getTypeName(this.TypeName, isRequired);
        }

        public string DecodeTypeDeclaration(bool isRequired)
        {
            return SwiftNameHelper.getTypeName(this.TypeName, isRequired);
        }

        public string VariableName
        {
            get
            {
                return SwiftNameHelper.convertToVariableName(this.Name);
            }
        }

        public string TypeName {
            get {
                return this.Name + "Data";
            }
        }

        public bool HasRequiredFields {
            get {
                if (BaseModelType != null)
                {
                    if(((CompositeTypeSwift)BaseModelType).HasRequiredFields) {
                        return true;
                    }
                }

                return this.Properties.Where(x => x.IsRequired).Count() > 0;
            }
        }

        public void SetDecodeDate(String propName, PropertySwift property, IndentedStringBuilder indented) {
            var modelType = property.ModelType as PrimaryTypeSwift;
            var formatString = String.Empty;
            if(modelType != null) {
                switch (modelType.KnownPrimaryType)
                {
                    case KnownPrimaryType.Date:
                        formatString = "date";
                        break;
                    case KnownPrimaryType.DateTime:
                        formatString = "dateTime";
                        break;
                    case KnownPrimaryType.DateTimeRfc1123:
                        formatString = "dateTimeRfc1123";
                        break;
                    default:
                        throw new Exception("Date format unknown");
                }

                indented.Append($"    self.{propName} = DateConverter.fromString(dateStr: (try container.decode(String?.self, forKey: .{propName})), format: .{formatString})" + 
                    (property.IsRequired ? "!" : "") + "\r\n");
                return;
            }

            throw new Exception("Date format unknown");
        }

        public void SetEncodeDate(String propName, PropertySwift property, IndentedStringBuilder indented) {
            var modelType = property.ModelType as PrimaryTypeSwift;
            var formatString = String.Empty;
            if(modelType != null) {
                switch (modelType.KnownPrimaryType)
                {
                    case KnownPrimaryType.Date:
                        formatString = "date";
                        break;
                    case KnownPrimaryType.DateTime:
                        formatString = "dateTime";
                        break;
                    case KnownPrimaryType.DateTimeRfc1123:
                        formatString = "dateTimeRfc1123";
                        break;
                    default:
                        throw new Exception("Date format unknown");
                }

                if (property.IsRequired)
                {
                    indented.Append($"try container.encode(DateConverter.toString(date: self.{propName}, format: .{formatString}), forKey: .{propName})\r\n");
                }
                else
                {
                    indented.Append($"if self.{propName} != nil {{\r\n");
                    indented.Append($"    try container.encode(DateConverter.toString(date: self.{propName}!, format: .{formatString}), forKey: .{propName})\r\n");
                    indented.Append($"}}\r\n");
                }

                return;
            }

            throw new Exception("Date format unknown");
        }
    }
}
