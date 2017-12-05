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

        public string VariableTypeDeclaration
        {
            get
            {
                if (ElementType is IVariableType)
                {
                    return $"[{((IVariableType)ElementType).VariableTypeDeclaration}]?";
                }

                return $"[{ElementType.Name}?]?";
            }
        }

        public string DecodeTypeDeclaration
        {
            get
            {
                if (ElementType is IVariableType)
                {
                    return $"[{((IVariableType)ElementType).DecodeTypeDeclaration}]?";
                }

                return $"[{ElementType.Name}]?";
            }
        }

        public string EncodeTypeDeclaration
        {
            get
            {
                if (ElementType is IVariableType)
                {
                    return $"[{((IVariableType)ElementType).EncodeTypeDeclaration}]?";
                }

                return $"[{ElementType.Name}]?";
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
