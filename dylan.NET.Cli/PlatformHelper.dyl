// Copyright (c) Dylan Borg. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

namespace dylan.NET.Cli

	class private static PlatformHelper

        property public static boolean IsMono
            get
                return Type::GetType("Mono.Runtime") isnot null
            end get
        end property

        property public static string DebugExtension
        	get
        		return #ternary {get_IsMono() ? ".dll.mdb" , ".pdb"}
        	end get
        end property

        property public static string ExeDebugExtension
        	get
        		return #ternary {get_IsMono() ? ".exe.mdb" , ".pdb"}
        	end get
        end property

    end class

end namespace
