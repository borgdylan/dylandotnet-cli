// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.
//adapted from .NET CLI source code

namespace Microsoft.DotNet.Cli.Utils

    class private static AnsiColorExtensions

        method public static string Black(var text as string)
            return c"\x1B[30m" + text + c"\x1B[39m"
        end method

        method public static string Red(var text as string)
            return c"\x1B[31m" + text + c"\x1B[39m"
        end method

        method public static string Green(var text as string)
            return c"\x1B[32m" + text + c"\x1B[39m"
        end method

        method public static string Yellow(var text as string)
            return c"\x1B[33m" + text + c"\x1B[39m"
        end method

        method public static string Blue(var text as string)
            return c"\x1B[34m" + text + c"\x1B[39m"
        end method

        method public static string Magenta(var text as string)
            return c"\x1B[35m" + text + c"\x1B[39m"
        end method

        method static string Cyan(var text as string)
            return c"\x1B[36m" + text + c"\x1B[39m"
        end method

        method public static string White(var text as string)
            return c"\x1B[37m" + text + c"\x1B[39m"
        end method

        method public static string Bold(var text as string)
            return c"\x1B[1m" + text + c"\x1B[22m"
        end method

    end class

end namespace
