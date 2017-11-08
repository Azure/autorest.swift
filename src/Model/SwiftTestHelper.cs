using AutoRest.Core.Model;
using System;
using System.Collections.Generic;
using System.Text;

namespace AutoRest.Swift.Model
{
    class SwiftTestHelper
    {
        public static String GetTestOutputForType(IModelType type)
        {
            if (type is CompositeType)
            {
                return ((IVariableType)type).VariableTypeDeclaration + "()";
            }
            else if (type is PrimaryType)
            {
                return SwiftTestHelper.GetPrimaryTypeDefault(type as PrimaryType);
            }
            else
            {
                return "nil";
            }
        }

        public static string GetPrimaryTypeDefault(PrimaryType type)
        {
            switch (type.KnownPrimaryType)
            {
                case KnownPrimaryType.Base64Url:
                    // TODO: add support
                    return "\"hello\"";

                case KnownPrimaryType.Boolean:
                    return "true";

                case KnownPrimaryType.Date:
                    return "0";

                case KnownPrimaryType.DateTime:
                    return "0";

                case KnownPrimaryType.DateTimeRfc1123:
                    return "0";

                case KnownPrimaryType.Double:
                    return "1.1";

                case KnownPrimaryType.Decimal:
                    return "1.1";

                case KnownPrimaryType.Int:
                    return "2";

                case KnownPrimaryType.Long:
                    return "3";

                case KnownPrimaryType.String:
                    return "\"hello world\"";

                case KnownPrimaryType.TimeSpan:
                    return "4";

                case KnownPrimaryType.Object:
                    // TODO: is this the correct way to support object types?
                    return "nil";

                case KnownPrimaryType.UnixTime:
                    return "1";

                case KnownPrimaryType.Uuid:
                    return "nil";

            }

            return "nil";
        }
    }
}
