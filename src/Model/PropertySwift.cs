// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Swift.Model
{
    public class PropertySwift : Property
    {
        public PropertySwift()
        {
            Name.OnGet += value =>
            {
                return value;
            };
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
                if (this.ModelType is IVariableType)
                {
                    return ((IVariableType)this.ModelType).VariableTypeDeclaration;
                }

                return this.ModelType.Name;
            }
        }

        public string DecodeTypeDeclaration
        {
            get
            {
                if (this.ModelType is IVariableType)
                {
                    return ((IVariableType)this.ModelType).VariableTypeDeclaration;
                }

                return this.ModelType.Name;
            }
        }

        public string EncodeTypeDeclaration
        {
            get
            {
                if (this.ModelType is IVariableType)
                {
                    return ((IVariableType)this.ModelType).EncodeTypeDeclaration;
                }

                return this.ModelType.Name;
            }
        }
    }
}
