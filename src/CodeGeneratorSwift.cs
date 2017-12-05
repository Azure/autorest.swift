// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Swift.Model;
using AutoRest.Swift.Templates;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace AutoRest.Swift
{
    public class CodeGeneratorSwift : CodeGenerator
    {
        public string Name
        {
            get { return "Swift"; }
        }

        public override string UsageInstructions
        {
            get { return string.Empty; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".swift"; }
        }

        /// <summary>
        /// Generates Go code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var codeModel = cm as CodeModelSwift;
            if (codeModel == null)
            {
                throw new Exception("Code model is not a Swift Code Model");
            }

            // unfortunately there is an ordering issue here.  during model generation we might
            // flatten some types (but not all depending on type).  then during client generation
            // the validation codegen needs to know if a type was flattened so it can generate
            // the correct code, so we need to generate models before clients.
            //Protocols
            foreach (CompositeTypeSwift modelType in cm.ModelTypes.Union(codeModel.HeaderTypes))
            {
                var modelProtocolTemplate = new ModelProtocolTemplate { Model = modelType };
                await Write(modelProtocolTemplate, Path.Combine("protocols", $"{modelType.Name}Protocol{ImplementationFileExtension}"));
            }

            //Models
            foreach (CompositeTypeSwift modelType in cm.ModelTypes.Union(codeModel.HeaderTypes))
            {
                var modelTemplate = new DataModelTemplate { Model = modelType };
                await Write(modelTemplate, Path.Combine("data", $"{modelType.TypeName}{ImplementationFileExtension}"));
            }

            //Model Tests
            foreach (CompositeTypeSwift modelType in cm.ModelTypes.Union(codeModel.HeaderTypes))
            {
                var modelTemplate = new DataModelTestTemplate { Model = modelType };
                //await Write(modelTemplate, Path.Combine("tests", $"{modelType.Name}Test{ImplementationFileExtension}"));
            }

            // Enums
            foreach (EnumTypeSwift enumType in cm.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate, Path.Combine("data", $"{enumTemplate.Model.Name}{ImplementationFileExtension}"));
            }

            // Command
            foreach (var methodGroup in codeModel.MethodGroups.Where(mg => !string.IsNullOrEmpty(mg.Name)))
            {
                foreach (var method in methodGroup.Methods)
                {
                    var methodContextTemplate = new MethodCommandTemplate
                    {
                        Model = (MethodSwift)method
                    };

                    //await Write(methodContextTemplate, Path.Combine("commands", $"{methodGroup.Name + method.Name}{ImplementationFileExtension}"));
                }
            }

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = codeModel
            };

            //await Write(serviceClientTemplate, $"{codeModel.ServiceName}{ImplementationFileExtension}");
            foreach (var methodGroup in codeModel.MethodGroups)
            {
                if(string.IsNullOrWhiteSpace(methodGroup.Name))
                {
                    methodGroup.Name = "Service";
                }

                var methodGroupTemplate = new MethodGroupTemplate
                {
                    Model = methodGroup
                };

                await Write(methodGroupTemplate, Path.Combine("commands", FormatFileName(methodGroup.Name).ToLowerInvariant()));
            }
        }

        private string FormatFileName(string fileName)
        {
            return $"{fileName}{ImplementationFileExtension}";
        }
    }
}
