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
