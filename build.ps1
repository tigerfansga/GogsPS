param ($Task = 'Default')

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Install-Module Psake, PSDeploy, BuildHelpers, PSScriptAnalyzer -force -Scope CurrentUser
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser
Import-Module Psake, BuildHelpers

Set-BuildEnvironment

Invoke-psake -buildFile .\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )