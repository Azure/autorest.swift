// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.Swift.Model
{
    public class ParameterSwift : Parameter, IVariableType
    {
        public const string APIVersionName = "APIVersion";
        public ParameterSwift()
        {

        }

        /// <summary>
        /// Add imports for the parameter in parameter type.
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            ModelType.AddImports(imports);
        }

        /// <summary>
        /// Return string with formatted Go map.
        /// xyz["abc"] = 123
        /// </summary>
        /// <param name="mapVariable"></param>
        /// <returns></returns>
        public string AddToMap(string mapVariable)
        {
            return string.Format("{0}[\"{1}\"] = {2}", mapVariable, NameForMap(), ValueForMap());
        }

        public override bool IsClientProperty => base.IsClientProperty == true && !IsAPIVersion;

        public virtual bool IsAPIVersion => SerializedName.IsApiVersion();

        public virtual bool IsMethodArgument => !IsClientProperty && !IsAPIVersion;

        /// <summary>
        /// Get Name for parameter for Go map. 
        /// If parameter is client parameter, then return client.<parametername>
        /// </summary>
        /// <returns></returns>
        public string NameForMap()
        {
            return IsAPIVersion
                     ? AzureExtensions.ApiVersion
                     : SerializedName;
        }

        public bool RequiresUrlEncoding()
        {
            return (Location == Core.Model.ParameterLocation.Query || Location == Core.Model.ParameterLocation.Path) && !Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension);
        }

        /// <summary>
        /// Return formatted value string for the parameter.
        /// </summary>
        /// <returns></returns>
        public string ValueForMap()
        {
            if (IsAPIVersion)
            {
                return APIVersionName;
            }

            var value = IsClientProperty
                ? "client." + CodeNamerSwift.Instance.GetPropertyName(Name.Value)
                : Name.Value;

            var format = IsRequired || ModelType.CanBeEmpty()
                                          ? "{0}"
                                          : "*{0}";

            var s = CollectionFormat != CollectionFormat.None
                                  ? $"{format},\"{CollectionFormat.GetSeparator()}\""
                                  : $"{format}";

            return string.Format(
                RequiresUrlEncoding()
                    ? $"autorest.Encode(\"{Location.ToString().ToLower()}\",{s})"
                    : $"{s}",
                value);
        }

        public string VariableName
        {
            get
            {
                return SwiftNameHelper.convertToVariableName(this.Name);
            }
        }

        public string VariableTypeDeclaration
        {
            get
            {
                return this.ModelType.Name;
            }
        }

        public string DecodeTypeDeclaration
        {
            get
            {
                return this.ModelType.Name;
            }
        }
    }
}
