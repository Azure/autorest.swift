// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Model;


namespace AutoRest.Swift.Model
{
    /// <summary>
    /// Defines a synthetic type used to hold an array or dictionary method response.
    /// </summary>
    public class DictionaryTypeSwift : DictionaryType, IVariableType
    {
        // if value type can be implicitly null
        // then don't emit it as a pointer type.
        private string FieldNameFormat => "[String:{0}]";

        public DictionaryTypeSwift()
        {
        }

        public bool IsRequired { get; set; }

        /// <summary>
        /// Add imports for dictionary type.
        /// </summary>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            ValueType.AddImports(imports);
        }

        public string GetEmptyCheck(string valueReference, bool asEmpty)
        {
            return string.Format(asEmpty
                                    ? "{0} == nil || len({0}) == 0"
                                    : "{0} != nil && len({0}) > 0", valueReference);
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on the ValueType.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var mapType = obj as DictionaryTypeSwift;

            if (mapType != null)
            {
                return mapType.ValueType == ValueType;
            }

            return false;
        }

        /// <summary>
        /// Returns the hash code for this instance.
        /// </summary>
        /// <returns>A 32-bit signed integer hash code.</returns>
        public override int GetHashCode()
        {
            return ValueType.GetHashCode();
        }

        public string DecodeTypeDeclaration(bool isRequired)
        {
                var retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        this.ValueType.Name);
                if (ValueType is IVariableType)
                {
                    retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        ((IVariableType)ValueType).DecodeTypeDeclaration(isRequired));
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string EncodeTypeDeclaration(bool isRequired)
        {
                var retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        this.ValueType.Name);
                if (ValueType is IVariableType)
                {
                    retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        ((IVariableType)ValueType).EncodeTypeDeclaration(isRequired));
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string VariableTypeDeclaration(bool isRequired)
        {
                var retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        this.ValueType.Name);
                if (ValueType is IVariableType)
                {
                    retVal = string.Format(CultureInfo.InvariantCulture, FieldNameFormat,
                        ((IVariableType)ValueType).VariableTypeDeclaration(isRequired));
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
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
