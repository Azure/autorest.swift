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

        public EnumTypeSwift()
        {
            // the default value for unnamed enums is "enum"
            Name.OnGet += v => v == "enum" ? "string" : v;

            // Assume members have unique names
            HasUniqueNames = true;
        }

        public EnumTypeSwift(EnumType source) : this()
        {
            this.LoadFrom(source);
        }

        public string GetEmptyCheck(string valueReference, bool asEmpty)
        {
            return string.Format(asEmpty
                                    ? "len(string({0})) == 0"
                                    : "len(string({0})) > 0", valueReference);
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

        public string DecodeTypeDeclaration
        {
            get
            {
                return this.Name + "?";
            }
        }

        public string VariableTypeDeclaration
        {
            get
            {
                return this.Name + "?";
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
