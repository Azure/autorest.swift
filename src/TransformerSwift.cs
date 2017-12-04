// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Swift.Model;
using AutoRest.Swift.Properties;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using AutoRest.Extensions.Azure;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swift
{
    public class TransformerSwift : CodeModelTransformer<CodeModelSwift>
    {
        private readonly Dictionary<IModelType, IModelType> _normalizedTypes;

        public TransformerSwift()
        {
            _normalizedTypes = new Dictionary<IModelType, IModelType>();
        }

        public override CodeModelSwift TransformCodeModel(CodeModel cm)
        {
            var cmg = cm as CodeModelSwift;

            SwaggerExtensions.ProcessGlobalParameters(cmg);
            // Add the current package name as a reserved keyword
            TransformEnumTypes(cmg);
            TransformModelTypes(cmg);
            TransformMethods(cmg);
            AppendTypeSpecifier(cmg);
            AzureExtensions.ProcessParameterizedHost(cmg);

            return cmg;
        }

        private void TransformEnumTypes(CodeModelSwift cmg)
        {
            // fix up any enum types that are missing a name.
            // NOTE: this must be done before the next code block
            foreach (var mt in cmg.ModelTypes)
            {
                foreach (var property in mt.Properties)
                {
                    if (property.ModelType is EnumTypeSwift)
                    {
                        var enumType = property.ModelType as EnumTypeSwift;

                        if (!enumType.IsNamed)
                        {
                            enumType.SetName(property.Name);
                        }
                    }
                }
            }

            // fix up any enum types that are missing a name.
            // NOTE: this must be done before the next code block
            foreach (var method in cmg.Methods)
            {
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ModelType is EnumTypeSwift)
                    {
                        var enumType = parameter.ModelType as EnumTypeSwift;

                        if (!enumType.IsNamed)
                        {
                            var typeName = SwiftNameHelper.convertToValidSwiftTypeName(parameter.Name);
                            enumType.SetName($"{method.Name}{typeName}");
                            enumType.UnNamedEnumRelatedType = new EnumTypeSwift(enumType);
                            cmg.Add(enumType.UnNamedEnumRelatedType);
                    }
                    }
                }
            }

            // And add any others with a defined name and value list (but not already located)
            foreach (var mt in cmg.ModelTypes)
            {
                var namedEnums = mt.Properties.Where(p => p.ModelType is EnumTypeSwift && (p.ModelType as EnumTypeSwift).IsNamed);
                foreach (var p in namedEnums)
                {
                    if (!cmg.EnumTypes.Any(etm => etm.Equals(p.ModelType)))
                    {
                        ((EnumTypeSwift)p.ModelType).UnNamedEnumRelatedType = new EnumTypeSwift(p.ModelType as EnumType);
                        cmg.Add(((EnumTypeSwift)p.ModelType).UnNamedEnumRelatedType);
                    }
                };
            }


            // now normalize the names
            // NOTE: this must be done after all enum types have been accounted for
            foreach (var enumType in cmg.EnumTypes)
            {
                enumType.SetName(CodeNamer.Instance.GetTypeName(enumType.Name.FixedValue));
                foreach (var v in enumType.Values)
                {
                    v.Name = CodeNamer.Instance.GetEnumMemberName(v.Name);
                }
            }
 
            // Ensure all enumerated type values have the simplest possible unique names
            // -- The code assumes that all public type names are unique within the client and that the values
            //    of an enumerated type are unique within that type. To safely promote the enumerated value name
            //    to the top-level, it must not conflict with other existing types. If it does, prepending the
            //    value name with the (assumed to be unique) enumerated type name will make it unique.

            // First, collect all type names (since these cannot change)
            var topLevelNames = new HashSet<string>();
            cmg.ModelTypes
                .ForEach(mt => topLevelNames.Add(mt.Name));

            // Then, note each enumerated type with one or more conflicting values and collect the values from
            // those enumerated types without conflicts.  do this on a sorted list to ensure consistent naming
            cmg.EnumTypes.Cast<EnumTypeSwift>().OrderBy(etg => etg.Name.Value)
                .ForEach(em =>
                {
                    if (em.Values.Where(v => topLevelNames.Contains(v.Name) || CodeNamerSwift.Instance.UserDefinedNames.Contains(v.Name)).Count() > 0)
                    {
                        em.HasUniqueNames = false;
                    }
                    else
                    {
                        em.HasUniqueNames = true;
                        topLevelNames.UnionWith(em.Values.Select(ev => ev.Name).ToList());
                    }
                });
 
            // add documentation comment if there aren't any
            cmg.EnumTypes.Cast<EnumTypeSwift>()
                .ForEach(em =>
                {
                    if (em.Name.Equals("enum"))
                    {
                        em.Name.FixedValue = em.ClassName;
                    }

                    if (string.IsNullOrEmpty(em.Documentation))
                    {
                        em.Documentation = string.Format("{0} enumerates the values for {1}.", em.Name, em.Name.FixedValue.ToPhrase());
                    }
                });
        }

        private void TransformModelTypes(CodeModelSwift cmg)
        {
            foreach (var ctg in cmg.ModelTypes.Cast<CompositeTypeSwift>())
            {
                var name = ctg.Name.FixedValue.TrimPackageName(cmg.Namespace);

                // ensure that the candidate name isn't already in use
                if (name != ctg.Name && cmg.ModelTypes.Any(mt => mt.Name == name))
                {
                    name = $"{name}Type";
                }

                if (CodeNamerSwift.Instance.UserDefinedNames.Contains(name))
                {
                    name = $"{name}{cmg.Namespace.Capitalize()}";
                }

                ctg.SetName(name);
            }

            // Find all methods that returned paged results
            cmg.Methods.Cast<MethodSwift>()
                .Where(m => m.IsPageable).ToList()
                .ForEach(m =>
                {
                    if (!cmg.PagedTypes.ContainsKey(m.ReturnValue().Body))
                    {
                        cmg.PagedTypes.Add(m.ReturnValue().Body, m.NextLink);
                    }

                    if (!m.NextMethodExists(cmg.Methods.Cast<MethodSwift>()))
                    {
                        cmg.NextMethodUndefined.Add(m.ReturnValue().Body);
                    }
                });

            // Mark all models returned by one or more methods and note any "next link" fields used with paged data
            cmg.ModelTypes.Cast<CompositeTypeSwift>()
                .Where(mtm =>
                {
                    return cmg.Methods.Cast<MethodSwift>().Any(m => m.HasReturnValue() && m.ReturnValue().Body.Equals(mtm));
                }).ToList()
                .ForEach(mtm =>
                {
                    mtm.IsResponseType = true;
                    if (cmg.PagedTypes.ContainsKey(mtm))
                    {
                        mtm.NextLink = CodeNamerSwift.Instance.GetPropertyName(cmg.PagedTypes[mtm]);
                        mtm.PreparerNeeded = cmg.NextMethodUndefined.Contains(mtm);
                    }
                });

            foreach (var mtm in cmg.ModelTypes)
            {
                if (mtm.IsPolymorphic)
                {
                    foreach (var dt in (mtm as CompositeTypeSwift).DerivedTypes)
                    {
                        (dt as CompositeTypeSwift).DiscriminatorEnum = (mtm as CompositeTypeSwift).DiscriminatorEnum;
                    }

                }
            }
        }

        private void TransformMethods(CodeModelSwift cmg)
        {
            foreach (var mg in cmg.MethodGroups)
            {
                mg.Transform(cmg);
            }

            var wrapperTypes = new Dictionary<string, CompositeTypeSwift>();
            foreach (var method in cmg.Methods)
            {
                ((MethodSwift)method).Transform(cmg);

                var scope = new VariableScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = scope.GetVariableName(parameter.Name);
                }
            }
        }

        private void AppendTypeSpecifier(CodeModelSwift cmg)
        {
            var exportedTypes = new HashSet<object>();
            exportedTypes.UnionWith(cmg.EnumTypes);
            exportedTypes.UnionWith(cmg.Methods);
            exportedTypes.UnionWith(cmg.ModelTypes);

            exportedTypes.ForEach(exported =>
                {
                    var name = exported is IModelType
                                    ? (exported as IModelType).Name
                                    : (exported as Method).Name;

                    name = name.Value.TrimPackageName(cmg.Namespace);

                    var nameInUse = exportedTypes
                                        .Any(et => (et != exported && et is IModelType && (et as IModelType).Name.Equals(name)) || (et is Method && (et as Method).Name.Equals(name)));
                    if (exported is EnumType)
                    {
                        (exported as EnumType).Name.FixedValue = CodeNamerSwift.AttachTypeName(name, cmg.Namespace, nameInUse, "Enum");
                    }
                    else if (exported is CompositeType)
                    {
                        (exported as CompositeType).Name.FixedValue = CodeNamerSwift.AttachTypeName(name, cmg.Namespace, nameInUse, "Type");
                    }
                    else if (exported is Method)
                    {
                        (exported as Method).Name.FixedValue = CodeNamerSwift.AttachTypeName(name, cmg.Namespace, nameInUse, "");
                    }
                });
        }
    }
}
