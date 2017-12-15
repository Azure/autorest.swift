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

        public string VariableTypeDeclaration(bool isRequired)
        {
                var retVal = this.ModelType.Name;
                if (this.ModelType is IVariableType)
                {
                    retVal = ((IVariableType)this.ModelType).VariableTypeDeclaration(isRequired);
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string EncodeTypeDeclaration(bool isRequired)
        {
                var retVal = this.ModelType.Name;
                if (this.ModelType is IVariableType)
                {
                    retVal = ((IVariableType)this.ModelType).EncodeTypeDeclaration(isRequired);
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
        }

        public string DecodeTypeDeclaration(bool isRequired)
        {
                var retVal = this.ModelType.Name;
                if (this.ModelType is IVariableType)
                {
                    retVal = ((IVariableType)this.ModelType).DecodeTypeDeclaration(isRequired);
                }

                return SwiftNameHelper.getTypeName(retVal, isRequired);
        }
    }
}
