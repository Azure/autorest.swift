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
                name = name.Replace(" ", "").Replace("-", "");
                name = name.Substring(0, 1).ToLower() + name.Substring(1);
            }

            if(name.Equals("body", StringComparison.OrdinalIgnoreCase)) {
                name = "_body";
            }

            if(CodeNamerSwift.reservedWords.Contains(name)) {
                name = "_" + name;
            }
            
            return name;
        }

        internal static string convertToValidSwiftTypeName(string name)
        {
            if (!string.IsNullOrWhiteSpace(name) && name.Length > 1)
            {
                name = name.Replace(" ", "").Replace("-", "");
                
                name = name.Substring(0, 1).ToUpper() + name.Substring(1);

            }

            if(CodeNamerSwift.reservedWords.Contains(name)) {
                name = "_" + name;
            }
            
            return name;
        }

        internal static string getTypeName(string name, bool isRequired)
        {
            return name + (isRequired || name.EndsWith("?") ? "" : "?");
        }
    }
}
