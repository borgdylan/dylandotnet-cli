# dylandotnet-cli
dylan.NET support for .NET CLI

This repository houses an experimental rendition of what will become the dylan.NET support for the .NET CLI. The code in the ```dylan.NET/Cli``` folder self-compiles using binaries that I left in the ```build``` folder. The build happens via GNU Make so the build does require ```make``` and a ```bash``` shell environment. Do notice that the produced ```dotnet-compile-dnc``` command is dependent on the full .NET Framework or Mono with the ```.NET 4.5.1``` profile being required. The compiler is brought in as a library set and invoked using a regular method call.

Notice
------

There is some code that was copied over from the .NET CLI source at http://github.com/dotnet/cli and then translated into dylan.NET. Those files still attribute copyright to the .NET Foundation. The files written by me attribute copyright to me. My changes use the same license used by the .NET CLI i.e. the MIT License.