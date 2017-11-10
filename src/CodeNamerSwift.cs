// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Core.Model;
using AutoRest.Swift.Model;
using System.Text;
using System.Text.RegularExpressions;

namespace AutoRest.Swift
{
    public class CodeNamerSwift : CodeNamer
    {
        public new static CodeNamerSwift Instance
        {
            get
            {
                return (CodeNamerSwift)CodeNamer.Instance;
            }
        }

        public virtual IEnumerable<string> AutorestImports => new string[] { PrimaryTypeSwift.GetImportLine(package: "SwiftAutorest") };

        private HashSet<string> CommonInitialisms => new HashSet<string>(StringComparer.OrdinalIgnoreCase) {
                                                            "Acl",
                                                            "Api",
                                                            "Ascii",
                                                            "Cpu",
                                                            "Css",
                                                            "Dns",
                                                            "Eof",
                                                            "Guid",
                                                            "Html",
                                                            "Http",
                                                            "Https",
                                                            "Id",
                                                            "Ip",
                                                            "Json",
                                                            "Lhs",
                                                            "Qps",
                                                            "Ram",
                                                            "Rhs",
                                                            "Rpc",
                                                            "Sla",
                                                            "Smtp",
                                                            "Sql",
                                                            "Ssh",
                                                            "Tcp",
                                                            "Tls",
                                                            "Ttl",
                                                            "Udp",
                                                            "Ui",
                                                            "Uid",
                                                            "Uuid",
                                                            "Uri",
                                                            "Url",
                                                            "Utf8",
                                                            "Vm",
                                                            "Xml",
                                                            "Xsrf",
                                                            "Xss",
                                                        };

        public string[] UserDefinedNames => new string[] {
                                                            "UserAgent",
                                                            "Version",
                                                            "APIVersion",
                                                            "DefaultBaseURI",
                                                            "ManagementClient",
                                                            "NewWithBaseURI",
                                                            "New",
                                                            "NewWithoutDefaults",
                                                        };


        /// <summary>
        /// Formats a string to work around golint name stuttering
        /// Refactor -> CodeModelTransformer
        /// </summary>
        /// <param name="name"></param>
        /// <param name="packageName"></param>
        /// <param name="nameInUse"></param>
        /// <param name="attachment"></param>
        /// <returns>The formatted string</returns>
        public static string AttachTypeName(string name, string packageName, bool nameInUse, string attachment)
        {
            return nameInUse
                ? name.Equals(packageName, StringComparison.OrdinalIgnoreCase)
                    ? name
                    : name + attachment
                : name;
        }

        public override string GetEnumMemberName(string member) {
            string retVal = SwiftNameHelper.convertToValidSwiftTypeName(base.GetEnumMemberName(member));
            retVal = retVal.Replace(" ", "");
            return retVal;
        }
    }
}