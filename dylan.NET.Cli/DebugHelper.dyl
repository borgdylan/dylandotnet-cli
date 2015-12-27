// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.
//adapted from .NET CLI source code

namespace Microsoft.DotNet.Cli.Utils

    class private static DebugHelper

        method private static void WaitForDebugger()
            Console::WriteLine("Waiting for debugger to attach. Press ENTER to continue")
            Console::WriteLine(i"Process ID: {Process::GetCurrentProcess()::get_Id()}")
            Console::ReadLine()
        end method

        [method: Conditional("DEBUG")]
        method public static void HandleDebugSwitch(var args as string[]&)
            if args[l] > 0 andalso string::Equals("--debug", args[0], StringComparison::OrdinalIgnoreCase) then
                args = Enumerable::ToArray<of string>(Enumerable::Skip<of string>(args, 1))
                WaitForDebugger()
            end if
        end method

    end class

end namespace