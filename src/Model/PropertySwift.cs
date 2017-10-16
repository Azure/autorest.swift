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

        }

        public string JsonTag(bool omitEmpty = true)
        {
            return string.Format("`json:\"{0}{1}\"`", SerializedName, omitEmpty ? ",omitempty" : "");
        }
    }
}
