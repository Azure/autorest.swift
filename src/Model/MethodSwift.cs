// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swift.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;

namespace AutoRest.Swift.Model
{
    public class MethodSwift : Method
    {
        public string Owner { get; private set; }

        public string PackageName { get; private set; }

        public string APIVersion { get; private set; }

        private readonly string lroDescription = " This method may poll for completion. Polling can be canceled by passing the cancel channel argument. " +
                                                 "The channel will be used to cancel polling and any outstanding HTTP requests.";

        public bool NextAlreadyDefined { get; private set; }

        public bool IsCustomBaseUri
            => CodeModel.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public MethodSwift()
        {
            NextAlreadyDefined = true;
        }

        public string CommandModelName
        {
            get { return this.MethodGroup.Name + this.Name + "Command";  }
        }

        internal void Transform(CodeModelSwift cmg)
        {
            
            Owner = (MethodGroup as MethodGroupSwift).ClientName;
            PackageName = cmg.Namespace;
            NextAlreadyDefined = NextMethodExists(cmg.Methods.Cast<MethodSwift>());

            var apiVersionParam =
              from p in Parameters
              let name = p.SerializedName
              where name != null && name.IsApiVersion()
              select p.DefaultValue.Value?.Trim(new[] { '"' });

            // When APIVersion is blank, it means that it was unavailable at the method level
            // and we should default back to whatever is present at the client level. However,
            // we will continue embedding that in each method to have broader support.
            APIVersion = apiVersionParam.SingleOrDefault();
            if (APIVersion == default(string))
            {
                APIVersion = cmg.ApiVersion;
            }

            var parameter = Parameters.ToList().Find(p => p.ModelType.PrimaryType(KnownPrimaryType.Stream)
                                                && !(p.Location == ParameterLocation.Body || p.Location == ParameterLocation.FormData));

            if (parameter != null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    Resources.IllegalStreamingParameter, parameter.Name));
            }
            if (string.IsNullOrEmpty(Description))
            {
                Description = string.Format("sends the {0} request.", Name.ToString().ToPhrase());
            }

            if (IsLongRunningOperation())
            {
                Description += lroDescription;
            }
        }

        public string MethodSignature => $"{Name}({MethodParametersSignature})";
        
        public string ParametersDocumentation
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                return sb.ToString();
            }
        }

        public PropertySwift ListElement
        {
            get
            {
                var body = ReturnType.Body as CompositeTypeSwift;
                return body.Properties.Where(p => p.ModelType is ArrayTypeSwift).FirstOrDefault() as PropertySwift;
            }
        }

        /// <summary>
        /// Generate the method parameter declaration.
        /// </summary>
        public string MethodParametersSignature
        {
            get
            {
                List<string> declarations = new List<string>();
                return string.Join(", ", declarations);
            }
        }

        /// <summary>
        /// Returns true if this method should return its results via channels.
        /// </summary>
        public bool ReturnViaChannel
        {
            get
            {
                // pageable operations will be handled separately
                return IsLongRunningOperation() && !IsPageable;
            }
        }

        /// <summary>
        /// Gets the return type name for this method.
        /// </summary>
        public string MethodReturnType
        {
            get
            {
                return HasReturnValue() ?
                    ((ReturnValue().Body is IVariableType) ? 
                        ((IVariableType)ReturnValue().Body).VariableTypeDeclaration 
                            : ReturnValue().Body.Name.ToString()) 
                        : "Void";
            }
        }

        /// <summary>
        /// Returns the method return signature for this method (e.g. "foo, bar").
        /// </summary>
        /// <param name="helper">Indicates if this method is a helper method (i.e. preparer/sender/responder).</param>
        /// <returns>The method signature for this method.</returns>
        public string MethodReturnSignature(bool helper)
        {
            var retValType = MethodReturnType;
            return $"{retValType}";
        }

        public IReadOnlyList<ParameterSwift> URLParameters
        {
            get
            {
                return Parameters.Where(x => { return x.Location == ParameterLocation.Path; })
                    .Select(x => { return (ParameterSwift)x; }).ToList();
            }
        }

        public IReadOnlyList<ParameterSwift> QueryParameters
        {
            get
            {
                return Parameters.Where(x => { return x.Location == ParameterLocation.Query; })
                    .Select(x => { return (ParameterSwift)x; }).ToList();
            }
        }

        public IReadOnlyList<ParameterSwift> HeaderParameters
        {
            get
            {
                return Parameters.Where(x => { return x.Location == ParameterLocation.Header; })
                    .Select(x => { return (ParameterSwift)x; }).ToList();
            }
        }

        public ParameterSwift BodyParameter
        {
            get
            {
                return Parameters.Where(x => { return x.Location == ParameterLocation.Body; })
                    .Select(x => { return (ParameterSwift)x; }).FirstOrDefault();
            }
        }

        public string ServiceModelName
        {
            get
            {
                return ((CodeModelSwift)this.CodeModel).ServiceName;
            }
        }

        /// <summary>
        /// Check if method has a return response.
        /// </summary>
        /// <returns></returns>
        public bool HasReturnValue()
        {
            return ReturnValue()?.Body != null;
        }

        /// <summary>
        /// Return response object for the method.
        /// </summary>
        /// <returns></returns>
        public Response ReturnValue()
        {
            return ReturnType ?? DefaultResponse;
        }

        /// <summary>
        /// Return response object for the method.
        /// </summary>
        /// <returns></returns>
        public string ReturnTypeDeclaration()
        {
            if (this.HasReturnValue())
            {
                if(this.ReturnType.Body is IVariableType)
                {
                    return ((IVariableType)this.ReturnType.Body).VariableTypeDeclaration;
                }else
                {
                    return this.ReturnType.Body.Name;
                }
            }
            else
            {
                return "Void";
            }
        }

        /// <summary>
        /// Checks if method has pageable extension (x-ms-pageable) enabled.  
        /// </summary>
        /// <returns></returns>

        public bool IsPageable => !string.IsNullOrEmpty(NextLink);

        public bool IsNextMethod => Name.Value.EqualsIgnoreCase(NextOperationName);

        /// <summary>
        /// Checks if method for next page of results on paged methods is already present in the method list.
        /// </summary>
        /// <param name="methods"></param>
        /// <returns></returns>
        public bool NextMethodExists(IEnumerable<MethodSwift> methods)
        {
            string next = NextOperationName;
            if (string.IsNullOrEmpty(next))
            {
                return false; 
            }
            return methods.Any(m => m.Name.Value.EqualsIgnoreCase(next));
        }

        public MethodSwift NextMethod
        {
            get
            {
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());
                    if (pageableExtension != null && !string.IsNullOrWhiteSpace(pageableExtension.OperationName))
                    {
                        return (CodeModel.Methods.First(m => m.SerializedName.EqualsIgnoreCase(pageableExtension.OperationName)) as MethodSwift);
                    }
                }
                return null;
            }
        }

        public string NextOperationName
        {
            get
            {
                return NextMethod?.Name.Value;
            }
        }

        public Method NextOperation
        {
            get
            {
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());
                    if (pageableExtension != null && !string.IsNullOrWhiteSpace(pageableExtension.OperationName))
                    {
                        return CodeModel.Methods.First(m => m.SerializedName.EqualsIgnoreCase(pageableExtension.OperationName));
                    }
                }
                return null;
            }
        }

        /// <summary>
        /// Check if method has long running extension (x-ms-long-running-operation) enabled. 
        /// </summary>
        /// <returns></returns>
        public bool IsLongRunningOperation()
        {
            try
            {
                return Extensions.ContainsKey(AzureExtensions.LongRunningExtension) && (bool)Extensions[AzureExtensions.LongRunningExtension];
            }
            catch (InvalidCastException e)
            {
                var message = $@"{
                    e.Message
                    } The value \'{
                    Extensions[AzureExtensions.LongRunningExtension]
                    }\' for extension {
                    AzureExtensions.LongRunningExtension
                    } for method {
                    Group
                    }. {
                    Name
                    } is invalid in Swagger. It should be boolean.";

                throw new InvalidOperationException(message);
            }
        }

        /// <summary>
        /// Add NextLink attribute for pageable extension for the method.
        /// </summary>
        /// <returns></returns>
        public string NextLink
        {
            get
            {
                // Note:
                // Methods can be paged, even if "nextLinkName" is null
                // Paged method just means a method returns an array
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (pageableExtension != null)
                    {
                        var nextLink = (string)pageableExtension["nextLinkName"];
                        if (!string.IsNullOrEmpty(nextLink))
                        {
                            return CodeNamerSwift.Instance.GetPropertyName(nextLink);
                        }
                    }
                }
                return null;
            }
        }
    }
}
