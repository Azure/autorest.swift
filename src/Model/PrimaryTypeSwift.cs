// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Swift;
using System;
using System.Collections.Generic;
using System.Text;

namespace AutoRest.Swift.Model
{
    public class PrimaryTypeSwift : PrimaryType
    {
        public PrimaryTypeSwift() : base()
        {
            Name.OnGet += v =>
            {
                return ImplementationName;
            };
        }

        public PrimaryTypeSwift(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v =>
            {
                return ImplementationName;
            };
        }

        /// <summary>
        /// Add imports for primary type.
        /// </summary>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            if (!string.IsNullOrWhiteSpace(Import))
                imports.Add(Import);
        }

        public virtual string Import
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Date:
                        return GetImportLine(package: "github.com/Azure/go-autorest/autorest/date");
                    case KnownPrimaryType.DateTimeRfc1123:
                        return GetImportLine(package: "github.com/Azure/go-autorest/autorest/date");
                    case KnownPrimaryType.DateTime:
                        return GetImportLine(package: "github.com/Azure/go-autorest/autorest/date");
                    case KnownPrimaryType.Decimal:
                        return GetImportLine(package: "github.com/shopspring/decimal");
                    case KnownPrimaryType.Stream:
                        return GetImportLine(package: "io");
                    case KnownPrimaryType.UnixTime:
                        return GetImportLine(package: "github.com/Azure/go-autorest/autorest/date");
                    case KnownPrimaryType.Uuid:
                        return GetImportLine(package: "github.com/satori/go.uuid", alias: "uuid");
                    default:
                        return string.Empty;
                }
            }
        }

        public virtual string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                        // TODO: add support
                        return "String?";

                    case KnownPrimaryType.Boolean:
                        return "Bool?";

                    case KnownPrimaryType.Date:
                        return "Int32?";

                    case KnownPrimaryType.DateTime:
                        return "Int32?";

                    case KnownPrimaryType.DateTimeRfc1123:
                        return "Int32?";

                    case KnownPrimaryType.Double:
                        return "Double?";

                    case KnownPrimaryType.Decimal:
                        return "Decimal?";

                    case KnownPrimaryType.Int:
                        return "Int32?";

                    case KnownPrimaryType.Long:
                        return "Int64?";

                    case KnownPrimaryType.String:
                        return "String?";

                    case KnownPrimaryType.TimeSpan:
                        return "Int64?";

                    case KnownPrimaryType.Object:
                        // TODO: is this the correct way to support object types?
                        return "[String: String?]?";

                    case KnownPrimaryType.UnixTime:
                        return "Int64?";

                    case KnownPrimaryType.Uuid:
                        return "NSUUID?";

                }

                throw new NotImplementedException($"Primary type {KnownPrimaryType} is not implemented in {GetType().Name}");
            }
        }

        public static string GetImportLine(string package, string alias = default(string)) {
            var builder = new StringBuilder();
            if(!string.IsNullOrEmpty(alias)){
                builder.Append(alias);
                builder.Append(' ');
            }

            builder.Append('"');
            builder.Append(package);
            builder.Append('"');
            return builder.ToString();
        }
    }
}
