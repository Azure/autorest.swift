// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swift.Model
{
    public class CodeModelSwift : CodeModel
    {

        private static readonly Regex semVerPattern = new Regex(@"^v?(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)(?:-(?<tag>\S+))?$", RegexOptions.Compiled);
        public string Version { get; }
        public string UserAgent
        {
            get
            {
                return $"Azure-SDK-For-Swift/{Version} arm-{Namespace}/{ApiVersion}";
            }
        }

        public CodeModelSwift()
        {
            NextMethodUndefined = new List<IModelType>();
            PagedTypes = new Dictionary<IModelType, string>();
            Version = FormatVersion(Settings.Instance.PackageVersion);
        }

        public string ServiceName => CodeNamer.Instance.PascalCase(Name ?? string.Empty);

        public string GetDocumentation()
        {
            return $"Package {Namespace} implements the Azure ARM {ServiceName} service API version {ApiVersion}.\n\n{(Documentation ?? string.Empty).UnwrapAnchorTags()}";
        }

        public string BaseClient => "ManagementClient";

        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public IEnumerable<string> ClientImports
        {
            get
            {
                var imports = new HashSet<string>();
                imports.UnionWith(CodeNamerSwift.Instance.AutorestImports);
                var clientMg = MethodGroups.Where(mg => string.IsNullOrEmpty(mg.Name)).FirstOrDefault();
                if (clientMg != null)
                {
                    imports.UnionWith(clientMg.Imports);
                }
                return imports.OrderBy(i => i);
            }
        }

        public string ClientDocumentation => string.Format("{0} is the base client for {1}.", BaseClient, ServiceName);

        public Dictionary<IModelType, string> PagedTypes { get; }

        // NextMethodUndefined is used to keep track of those models which are returned by paged methods,
        // but the next method is not defined in the service client, so these models need a preparer.
        public List<IModelType> NextMethodUndefined { get; }

        public IEnumerable<string> ModelImports
        {
            get
            {
                // Create an ordered union of the imports each model requires
                var imports = new HashSet<string>();
                if (ModelTypes != null && ModelTypes.Cast<CompositeTypeSwift>().Any(mtm => mtm.IsResponseType || mtm.IsWrapperType))
                {
                    imports.Add(PrimaryTypeSwift.GetImportLine("github.com/Azure/go-autorest/autorest"));
                }
                ModelTypes.Cast<CompositeTypeSwift>()
                    .ForEach(mt =>
                    {
                        mt.AddImports(imports);
                    });
                return imports.OrderBy(i => i);
            }
        }

        public virtual IEnumerable<MethodGroupSwift> MethodGroups => Operations.Cast<MethodGroupSwift>();

        public bool ShouldValidate => (bool)AutoRest.Core.Settings.Instance.Host?.GetValue<bool?>("client-side-validation").Result;

        public List<PropertySwift> GlobalParameters
        {
            get
            {
                return this.Properties.Where(p =>
                {
                    return !p.SerializedName.IsApiVersion();
                }).Select((p) => { return (PropertySwift)p; }).ToList();
            }
        }

        public IEnumerable<MethodSwift> ClientMethods
        {
            get
            {
                // client methods are the ones with no method group
                return Methods.Cast<MethodSwift>()
                    .Where(m => string.IsNullOrEmpty(m.MethodGroup.Name))
                    .OrderBy(m => m.Name.Value);
            }
        }

        /// FormatVersion normalizes a version string into a SemVer if it resembles one. Otherwise,
        /// it returns the original string unmodified. If version is empty or only comprised of
        /// whitespace, 
        public static string FormatVersion(string version)
        {
            if (string.IsNullOrWhiteSpace(version))
            {
                return "0.0.1";
            }

            var semVerMatch = semVerPattern.Match(version);

            if (semVerMatch.Success)
            {
                var builder = new StringBuilder("v");
                builder.Append(semVerMatch.Groups["major"].Value);
                builder.Append('.');
                builder.Append(semVerMatch.Groups["minor"].Value);
                builder.Append('.');
                builder.Append(semVerMatch.Groups["patch"].Value);
                if (semVerMatch.Groups["tag"].Success)
                {
                    builder.Append('-');
                    builder.Append(semVerMatch.Groups["tag"].Value);
                }
                return builder.ToString();
            }

            return version;
        }
    }
}
