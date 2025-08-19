#!/usr/bin/env bash

# update dependencies of a dotnet project
# https://stackoverflow.com/a/52387851/10440128

# fix: error MSB4019: The imported project ".../Microsoft.NET.Sdk.WindowsDesktop.targets" was not found.
# Confirm that the expression in the Import declaration "$(AfterMicrosoftNETSdkTargets)",
# which evaluated to ";.../Microsoft.NET.Sdk.WindowsDesktop.targets", is correct, and that the file exists on disk.
# Unable to create dependency graph file for project './HocrEditor/HocrEditor.csproj'. Cannot add package reference.
# this is dotnet 10.0.100-preview.7.25380.108 for windows x64
# https://dotnet.microsoft.com/en-us/download/dotnet/10.0
function dotnet() { wine ~/".wine/drive_c/Program Files/dotnet/dotnet.exe" "$@"; }

set -eux
regex='PackageReference Include="([^"]*)" Version="([^"]*)"'
find . -name "*.*proj" | while read proj
do
  while read line
  do
    if [[ $line =~ $regex ]]
    then
      name="${BASH_REMATCH[1]}"
      version="${BASH_REMATCH[2]}"
      if [[ $version != *-* ]]
      then
        dotnet add $proj package $name || true
      fi
    fi
  done < $proj
done
