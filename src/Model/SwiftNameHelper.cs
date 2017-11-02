using System;
using System.Collections.Generic;
using System.Text;

namespace AutoRest.Swift.Model
{
    internal static class SwiftNameHelper
    {
        internal static string convertToVariableName(string name)
        {
            if (!string.IsNullOrWhiteSpace(name) && name.Length > 1)
            {
                name = name.Substring(0, 1).ToLower() + name.Substring(1);
            }

            return name;
        }
    }
}
