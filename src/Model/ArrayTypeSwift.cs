// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using System.Collections.Generic;

namespace AutoRest.Swift.Model
{
    public class ArrayTypeSwift : SequenceType, IVariableType
    {
        public ArrayTypeSwift() : base()
        {
        }

        public string VariableTypeDeclaration(bool isRequired)
        {
            var retVal = $"[{ElementType.Name}]";
            if (ElementType is IVariableType)
            {
                retVal = $"[{((IVariableType)ElementType).VariableTypeDeclaration(isRequired)}]";
            }

            return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string DecodeTypeDeclaration(bool isRequired)
        {
            var retVal = $"[{ElementType.Name}]";
            if (ElementType is IVariableType)
            {
                retVal = $"[{((IVariableType)ElementType).DecodeTypeDeclaration(isRequired)}]";
            }

            return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string EncodeTypeDeclaration(bool isRequired)
        {
            var retVal = $"[{ElementType.Name}]";
            if (ElementType is IVariableType)
            {
                retVal = $"[{((IVariableType)ElementType).EncodeTypeDeclaration(isRequired)}]";
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
