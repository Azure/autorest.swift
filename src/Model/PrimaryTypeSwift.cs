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
        public bool IsRequired { get; set; }

        public PrimaryTypeSwift() : base()
        {
            Name.OnGet += v =>
            {
                return ImplementationName + (IsRequired ? "" : "?");
            };
        }

        public PrimaryTypeSwift(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v =>
            {
                return ImplementationName;
            };
        }

        public virtual string ImplementationName
        {
            get
            {
                
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                        // TODO: add support
                        return "String";

                    case KnownPrimaryType.Boolean:
                        return "Bool";

                    case KnownPrimaryType.Date:
                        return "String";

                    case KnownPrimaryType.DateTime:
                        return "String";

                    case KnownPrimaryType.DateTimeRfc1123:
                        return "String";

                    case KnownPrimaryType.Double:
                        return "Double";

                    case KnownPrimaryType.Decimal:
                        return "Decimal";

                    case KnownPrimaryType.Int:
                        return "Int32";

                    case KnownPrimaryType.Long:
                        return "Int64";

                    case KnownPrimaryType.String:
                        return "String";

                    case KnownPrimaryType.TimeSpan:
                        return "Int64";

                    case KnownPrimaryType.Object:
                        // TODO: is this the correct way to support object types?
                        return "[String: String?]";

                    case KnownPrimaryType.UnixTime:
                        return "Int64";

                    case KnownPrimaryType.Uuid:
                        return "NSUUID";

                    case KnownPrimaryType.Stream:
                        //return "NSData?";
                        return "String";
                    case KnownPrimaryType.ByteArray:
                        return "[UInt8]";

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
