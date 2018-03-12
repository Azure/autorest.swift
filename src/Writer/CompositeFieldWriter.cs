using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Swift.Model;

namespace AutoRest.Swift.Writer
{
    class CompositeFieldWriter
    {
        private CompositeTypeSwift compositeType;

        public CompositeFieldWriter(CompositeTypeSwift compositeType)
        {
            this.compositeType = compositeType;
        }

        public IEnumerableWithIndex<Property> Properties
        {
            get
            {
                this.compositeType.AddPolymorphicPropertyIfNecessary();
                return this.compositeType.Properties;
            }
        }

        public CompositeType BaseModelType
        {
            get
            {
                return this.compositeType.BaseModelType;
            }
        }

        public string FieldsAsString(bool forInterface = false)
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null && !forInterface)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.FieldsAsString(forInterface));
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                var modelType = property.ModelType;
                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                if (modelType is PrimaryTypeSwift)
                {
                    ((PrimaryTypeSwift)modelType).IsRequired = property.IsRequired;
                }

                var modelDeclaration = modelType.Name;
                if (modelType is PrimaryTypeSwift)
                {
                    modelDeclaration = SwiftNameHelper.getTypeName(modelType.Name, property.IsRequired);
                }
                else if (modelType is IVariableType)
                {
                    modelDeclaration = ((IVariableType)modelType).VariableTypeDeclaration(property.IsRequired);
                }

                var output = string.Empty;
                var propName = property.VariableName;
                var modifier = forInterface ? "" : "public";
                //TODO: need to handle flatten property case.
                output = string.Format("{2} var {0}: {1}",
                    propName,
                    modelDeclaration,
                    modifier);

                if (forInterface)
                {
                    output += " { get set }\n";
                }
                else
                {
                    output += "\n";
                }

                indented.Append(output);
            }

            return indented.ToString();
        }

        public string FieldEnumValuesForCodable(bool isTopLevel = false)
        {
            var indented = new IndentedStringBuilder("    ");
            if (isTopLevel)
            {
                indented.Append("enum CodingKeys: String, CodingKey {");
            }
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                var baseEnumValues = ((CompositeTypeSwift)BaseModelType).FieldWriter.FieldEnumValuesForCodable();
                if (baseEnumValues.Length > 0)
                {
                    this.compositeType.HasCodingKeys = true;
                    indented.Append(baseEnumValues);
                }
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                var propName = property.VariableName;
                var serializeName = property.SerializedName;
                this.compositeType.HasCodingKeys = true;
                indented.Append($"case {propName} = \"{serializeName}\"\r\n");
            }

            if (!this.compositeType.HasCodingKeys)
            {
                return "";
            }

            if (isTopLevel)
            {
                indented.Append("}");
            }

            return indented.ToString();
        }

        public string FieldEncodingString()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.FieldEncodingString());
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var propName = property.VariableName;
                var modelType = property.ModelType;
                if (modelType is PrimaryTypeSwift)
                {
                    ((PrimaryTypeSwift)modelType).IsRequired = property.IsRequired;
                }

                if (modelType is IVariableType &&
                    !(modelType is EnumType) &&
                    !(modelType is DictionaryType) &&
                    !string.IsNullOrEmpty(((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired)))
                {
                    if (property.IsRequired)
                    {
                        indented.Append($"try container.encode(self.{propName} as! {((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired)}, forKey: .{propName})\r\n");
                    }
                    else
                    {
                        indented.Append($"if self.{propName} != nil {{try container.encode(self.{propName} as! {((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired)}, forKey: .{propName})}}\r\n");
                    }
                }
                else
                {
                    if (modelType is PrimaryTypeSwift &&
                        "Date".Equals(modelType.Name))
                    {
                        this.compositeType.SetEncodeDate(propName, property, indented);
                    }
                    else if (property.IsRequired)
                    {
                        indented.Append($"try container.encode(self.{propName}, forKey: .{propName})\r\n");
                    }
                    else
                    {
                        indented.Append($"if self.{propName} != nil {{try container.encode(self.{propName}, forKey: .{propName})}}\r\n");
                    }

                }
            }

            return indented.ToString();
        }

        public string FieldDecodingString()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.FieldDecodingString());
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var propName = property.VariableName;
                var modelType = property.ModelType;
                if (modelType is PrimaryTypeSwift)
                {
                    ((PrimaryTypeSwift)modelType).IsRequired = property.IsRequired;
                }

                var modelDeclaration = modelType.Name;
                if (modelType is PrimaryTypeSwift)
                {
                    modelDeclaration = SwiftNameHelper.getTypeName(modelType.Name, property.IsRequired);
                }
                else if (modelType is IVariableType &&
                    !string.IsNullOrEmpty(((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired)))
                {
                    modelDeclaration = ((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired);
                }

                if (property.IsRequired)
                {
                    if (modelType is PrimaryTypeSwift &&
                        "Date".Equals(modelType.Name))
                    {
                        this.compositeType.SetDecodeDate(propName, property, indented);
                    }
                    else
                    {
                        indented.Append($"self.{propName} = try container.decode({modelDeclaration}.self, forKey: .{propName})\r\n");
                    }
                }
                else
                {
                    indented.Append($"if container.contains(.{propName}) {{\r\n");
                    if (modelType is PrimaryTypeSwift &&
                        "Date".Equals(modelType.Name))
                    {
                        this.compositeType.SetDecodeDate(propName, property, indented);
                    }
                    else
                    {
                        indented.Append($"    self.{propName} = try container.decode({modelDeclaration}.self, forKey: .{propName})\r\n");
                    }
                    indented.Append($"}}\r\n");
                }
            }

            return indented.ToString();
        }

        public string FieldsForTest()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.FieldsForTest());
            }

            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var propName = property.VariableName;
                var serializeName = property.SerializedName;
                indented.Append($"model.{propName} = nil\r\n");
            }

            return indented.ToString();
        }

        public string FieldsForValidation()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.FieldsForValidation());
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var propName = SwiftNameHelper.convertToValidSwiftTypeName(property.Name.RawValue);
                var modelType = property.ModelType;
                var modelDeclaration = modelType.Name;
                var serializeName = SwiftNameHelper.convertToValidSwiftTypeName(property.SerializedName);
                if (modelType is IVariableType &&
                    !string.IsNullOrEmpty(((IVariableType)modelType).DecodeTypeDeclaration(property.IsRequired)))
                {
                }
                else
                {
                }
            }

            return indented.ToString();
        }

        public string RequiredPropertiesForInitParameters(bool forMethodCall = false)
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            var seperator = "";
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.RequiredPropertiesForInitParameters(forMethodCall));
                if (indented.ToString().Length > 0)
                    seperator = ", ";
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var modelType = property.ModelType;
                if (modelType is PrimaryTypeSwift)
                {
                    ((PrimaryTypeSwift)modelType).IsRequired = property.IsRequired;
                }

                var modelDeclaration = modelType.Name;
                if (modelType is PrimaryTypeSwift)
                {
                    modelDeclaration = SwiftNameHelper.getTypeName(modelType.Name, property.IsRequired);
                }
                else if (modelType is IVariableType &&
                    !string.IsNullOrEmpty(((IVariableType)modelType).VariableTypeDeclaration(property.IsRequired)))
                {
                    modelDeclaration = ((IVariableType)modelType).VariableTypeDeclaration(property.IsRequired);
                }

                var output = string.Empty;
                var propName = property.VariableName;

                if (property.IsRequired)
                {
                    if (forMethodCall)
                    {
                        indented.Append($"{seperator}{propName}: {propName}");
                    }
                    else
                    {
                        indented.Append($"{seperator}{propName}: {modelDeclaration}");
                    }

                    seperator = ", ";
                }
            }

            return indented.ToString();
        }

        public string RequiredPropertiesSettersForInitParameters()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertySwift>().ToList();
            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeSwift)BaseModelType).FieldWriter.RequiredPropertiesSettersForInitParameters());
            }

            foreach (var property in properties)
            {
                if (property.ModelType == null)
                {
                    continue;
                }

                if (property.IsPolymorphicDiscriminator)
                {
                    continue;
                }

                var propName = property.VariableName;
                var modelType = property.ModelType;
                if (modelType is PrimaryTypeSwift)
                {
                    ((PrimaryTypeSwift)modelType).IsRequired = property.IsRequired;
                }

                var modelDeclaration = modelType.Name;
                if (modelType is PrimaryTypeSwift)
                {
                    modelDeclaration = SwiftNameHelper.getTypeName(modelType.Name, property.IsRequired);
                }
                else if (modelType is IVariableType &&
                    !string.IsNullOrEmpty(((IVariableType)modelType).VariableTypeDeclaration(property.IsRequired)))
                {
                    modelDeclaration = ((IVariableType)modelType).VariableTypeDeclaration(property.IsRequired);
                }

                if (property.IsRequired)
                {
                    indented.Append($"self.{propName} = {propName}\r\n");
                }
            }

            return indented.ToString();
        }
    }
}
