// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Swift;
using AutoRest.Extensions;

namespace AutoRest.Swift.Model
{
    public class MethodGroupSwift : MethodGroup
    {
        private string variableName;
        public string ClientName { get; private set; }
        public string Documentation { get; private set; }
        public string PackageName { get; private set; }
        public string BaseClient { get; private set; }

        public bool IsCustomBaseUri
            => CodeModel.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public List<PropertySwift> GlobalParameters;
        public IEnumerable<string> Imports { get; private set; }

        public MethodGroupSwift(string name) : base(name)
        {
        }

        public MethodGroupSwift()
        {
        }

        internal void Transform(CodeModelSwift cmg)
        {
            var originalName = Name.Value;
            Name = Name.Value.TrimPackageName(cmg.Namespace);
            if (Name != originalName)
            {
                // fix up the method group names
                cmg.Methods.Where(m => m.Group.Value == originalName)
                    .ForEach(m =>
                    {
                        m.Group = Name;
                    });
            }

            ClientName = string.IsNullOrEmpty(Name)
                            ? cmg.BaseClient
                            : TypeName.Value.IsNamePlural(cmg.Namespace)
                                             ? Name.Value
                                             : (Name.Value).TrimPackageName(cmg.Namespace);

            Documentation = string.Format("{0} is the {1} ", ClientName,
                                    string.IsNullOrEmpty(cmg.Documentation)
                                        ? string.Format("client for the {0} methods of the {1} service.", TypeName, cmg.ServiceName)
                                        : cmg.Documentation.ToSentence());

            PackageName = cmg.Namespace;
            BaseClient = cmg.BaseClient;
            GlobalParameters = cmg.GlobalParameters;
            
            //Imports
            var imports = new HashSet<string>();
            imports.UnionWith(CodeNamerSwift.Instance.AutorestImports);
        }

        internal string VariableName
        {
            get
            {
                //ok if race causes more than one call to pass.  Will be set to same value.
                if (string.IsNullOrWhiteSpace(this.variableName))
                {
                    this.variableName = SwiftNameHelper.convertToVariableName(this.Name);
                }

                return this.variableName;
            }
        }

        public string VariableDeclartionSyntax()
        {
            return $"var {this.VariableName}: {this.Name}";
        }
    }
}
