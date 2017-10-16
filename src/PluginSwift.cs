// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Swift.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swift
{
    public sealed class PluginSwift : Plugin<IGeneratorSettings, TransformerSwift, CodeGeneratorSwift, CodeNamerSwift, CodeModelSwift>
    {
        public PluginSwift()
        {
            Context = new Context {
                  // inherit base settings
                  Context,

                  // set code model implementations our own implementations 
                  new Factory<CodeModel, CodeModelSwift>(),
                  new Factory<Method, MethodSwift>(),
                  new Factory<CompositeType, CompositeTypeSwift>(),
                  new Factory<Property, PropertySwift>(),
                  new Factory<Parameter, ParameterSwift>(),
                  new Factory<DictionaryType, DictionaryTypeSwift>(),
                  new Factory<SequenceType, SequenceTypeSwift>(),
                  new Factory<MethodGroup, MethodGroupSwift>(),
                  new Factory<EnumType, EnumTypeSwift>(),
                  new Factory<PrimaryType, PrimaryTypeSwift>()
                };
        }
    }
}
