// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Swift.Model
{
    public class EnumTypeSwift : EnumType, IVariableType
    {
        public bool HasUniqueNames { get; set; }

        public EnumTypeSwift UnNamedEnumRelatedType { get; set; }

        public EnumTypeSwift()
        {
            // the default value for unnamed enums is "enum"
            Name.OnGet += (v) => {
                return v == "enum" ? "string" : v;
            };

            // Assume members have unique names
            HasUniqueNames = true;
        }

        public bool IsRequired { get; set; }

        public EnumTypeSwift(EnumType source) : this()
        {
            this.LoadFrom(source);
        }

        public bool IsNamed => Name != "string" && Values.Any();

        public IDictionary<string, string> Constants
        {
            get
            {
                var constants = new Dictionary<string, string>();
                Values
                    .ForEach(v =>
                    {
                        constants.Add(HasUniqueNames ? v.Name : Name + v.Name, v.SerializedName);
                    });

                return constants;
            }
        }

        public string Documentation { get; set; }

        public string DecodeTypeDeclaration(bool isRequired)
        {
            var retVal = this.Name.FixedValue;
            if (this.UnNamedEnumRelatedType != null)
            {
                return this.UnNamedEnumRelatedType.DecodeTypeDeclaration(isRequired);
            }

            return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string EncodeTypeDeclaration(bool isRequired)
        {
            var retVal = this.Name.FixedValue;
            if (this.UnNamedEnumRelatedType != null)
            {
                return this.UnNamedEnumRelatedType.EncodeTypeDeclaration(isRequired);
            }

            return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string VariableTypeDeclaration(bool isRequired)
        {
            var retVal = this.Name.FixedValue;
            if (this.UnNamedEnumRelatedType != null)
            {
                return this.UnNamedEnumRelatedType.VariableTypeDeclaration(isRequired);
            }

            return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string TypeName
        {
            get
            {
                var retVal = this.Name.FixedValue;
                if (this.UnNamedEnumRelatedType != null)
                {
                    return this.UnNamedEnumRelatedType.TypeName;
                }

                return retVal;
            }
        }

        public string VariableName
        {
            get
            {
                return SwiftNameHelper.convertToVariableName(this.Name);
            }
        }
    }
}
