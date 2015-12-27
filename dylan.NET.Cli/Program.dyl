﻿// Copyright (c) Dylan Borg. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

namespace dylan.NET.Cli

    class public Program

        field private literal integer ExitFailed = 1

        field private static CommonCompilerOptions commonOptions
        field private static AssemblyInfoOptions assemblyInfoOptions
        field private static string tempOutDir
        field private static string helpText
        field private static string outputName
        field private static IReadOnlyList<of string> references
        field private static IReadOnlyList<of string> resources
        field private static IReadOnlyList<of string> sources
        field private static boolean help

        method public static void DefineSyntax(var syntax as ArgumentSyntax)
            syntax::set_HandleHelp(false)
            syntax::set_HandleErrors(false)

            commonOptions = CommonCompilerOptionsExtensions::Parse(syntax)
            assemblyInfoOptions = AssemblyInfoOptions::Parse(syntax)

            syntax::DefineOption("temp-output", ref tempOutDir, "Compilation temporary directory")
            syntax::DefineOption("out", ref outputName, "Name of the output assembly")
            syntax::DefineOptionList("reference", ref references, "Path to a compiler metadata reference")
            syntax::DefineOptionList("resource", ref resources, "Resources to embed")
            syntax::DefineOption("h|help", ref help, "Help for compile native.")
            syntax::DefineParameterList("source-files", ref sources, "Compilation sources")

            helpText = syntax::GetHelpText()
        end method

        method assembly static void ErrorH(var cm as CompilerMsg)

		end method

		method assembly static void WarnH(var cm as CompilerMsg)

		end method

        method private static integer Main(var args as string[])
            DebugHelper::HandleDebugSwitch(ref args)

            help = false
            var returnCode = 0

            try
                ArgumentSyntax::Parse(args, new Action<of ArgumentSyntax>(DefineSyntax))
            catch exception as ArgumentSyntaxException
                Console::get_Error()::WriteLine(exception::get_Message())
                help = true
                returnCode = ExitFailed
            end try

            if help then
                Console::WriteLine(helpText)
                return returnCode
            end if

            if sources is null orelse sources::get_Count() == 0 orelse sources::get_Count() > 1 then
                Console::WriteLine(AnsiColorExtensions::Red("Please put a single file in the `compileFiles' list in project.json."))
                return 1
            end if

            var entryFile = sources::get_Item(0)
            var basePath = Path::GetDirectoryName(entryFile)
            var effectiveName as string = null
            var emitExe as boolean = false

            using sw = new StreamWriter(Path::Combine(basePath, "msbuild.dyl"))

                //referenced dlls
                foreach s in references
                    sw::WriteLine(i"#refasm \q{s}\q")
                end for

                //defines
                foreach s in commonOptions::get_Defines()
                    sw::WriteLine(i"#define {s}")
                end for

                //embedded resources
                if resources isnot null then
                    foreach s in resources
                        sw::WriteLine(i"#embed \q{s}\q")
                    end for
                end if

                //write out debug switch prference
                sw::WriteLine()
                sw::Write("#debug ")
                sw::WriteLine(#ternary { commonOptions::get_Optimize() ?? false ? "off" , "on"})
                sw::WriteLine()

                //write assembly attributes (similar set to the ones set by dotnet-compile-csc)

                //name
                if assemblyInfoOptions::get_Title() isnot null then
                    sw::WriteLine(i"[assembly: System.Reflection.AssemblyTitle(\q{assemblyInfoOptions::get_Title()}\q)]")
                end if

                //information version that includes stuff like alpha, beta etc.
                sw::WriteLine(i"[assembly: System.Reflection.AssemblyInformationalVersion(\q{assemblyInfoOptions::get_InformationalVersion()}\q)]")

                //file version that includes stuff like alpha, beta etc.
                sw::WriteLine(i"[assembly: System.Reflection.AssemblyFileVersion(\q{assemblyInfoOptions::get_AssemblyFileVersion()}\q)]")

                //get native code exceptions wrapped into something that inherits System.Exception
                sw::WriteLine("[assembly: System.Runtime.CompilerServices.RuntimeCompatibility(), WrapNonExceptionThrows = true]")

                //write out the TFM i.e. target framework moniker
                sw::WriteLine(i"[assembly: System.Runtime.Versioning.TargetFramework(\q{assemblyInfoOptions::get_TargetFramework()}\q)]")

                effectiveName = Path::GetFileNameWithoutExtension(outputName)::Replace("-", "_")
                emitExe = commonOptions::get_EmitEntryPoint() ?? false

                //define assembly accordignly
                sw::WriteLine()
                sw::Write("assembly ")
                sw::Write(effectiveName)
                sw::WriteLine(#ternary { emitExe ? " exe" , " dll" })

                //finalise assembly definition by issuing the version directive
                sw::WriteLine(i"ver {assemblyInfoOptions::get_AssemblyVersion()}")
            end using

            var w = new Action<of CompilerMsg>(WarnH)
			var e = new Action<of CompilerMsg>(ErrorH)
            var success as boolean = false

            try
                StreamUtils::add_WarnH(w)
                StreamUtils::add_ErrorH(e)

                StreamUtils::UseConsole = false
				var cd = Environment::get_CurrentDirectory()
				DNC.Program::Invoke(new string[] {"-inmemory", "-cd", basePath, entryFile})
				Environment::set_CurrentDirectory(cd)

                success = true
            catch
                success = false
            finally
                StreamUtils::remove_WarnH(w)
                StreamUtils::remove_ErrorH(e)
            end try

            if success then
                //write assembly to disk
                var asm = MemoryFS::GetFile(effectiveName + #ternary {emitExe ? ".exe" , ".dll"})
                using fs = File::OpenWrite(outputName)
                    asm::CopyTo(fs)
                end using
                asm::Dispose()

                //load debug symbols if they got made
                var pdbPath = Path::Combine(basePath, effectiveName + #ternary {emitExe ? PlatformHelper::get_ExeDebugExtension() , PlatformHelper::get_DebugExtension()})
                var pdbDestPath = Path::ChangeExtension(outputName, #ternary {emitExe ? PlatformHelper::get_ExeDebugExtension() , PlatformHelper::get_DebugExtension()})
                if !#expr(commonOptions::get_Optimize() ?? false) andalso File::Exists(pdbPath) then
                    File::Delete(pdbDestPath)
                    File::Move(pdbPath, pdbDestPath)
                end if
            end if

            return 0
        end method

    end class

end namespace
