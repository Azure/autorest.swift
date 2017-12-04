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

        public virtual bool IsAPIVersion => SerializedName.IsApiVersion();

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
                if(this.ModelType is IVariableType)
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

        public string DecodeTypeDeclaration
        {
            get
            {
                if (this.ModelType is IVariableType)
                {
                    return ((IVariableType)this.ModelType).DecodeTypeDeclaration;
                }

                return this.ModelType.Name;
            }
        }
    }
}
