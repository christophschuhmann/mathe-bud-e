param([ValidateSet('All', 'Windows', 'Android')][string]$Target = 'All')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
$flutterPath = if ($flutterCommand) { $flutterCommand.Source } else { $null }
if (-not $flutterPath) {
    foreach ($candidate in @("$env:USERPROFILE\development\flutter\bin\flutter.bat", "C:\dev\flutter\bin\flutter.bat")) {
        if (Test-Path -LiteralPath $candidate) { $flutterPath = $candidate; break }
    }
}
if (-not $flutterPath) { throw 'Flutter fehlt. Siehe README.md.' }
function Invoke-Flutter {
    param([string[]]$FlutterArgs)
    & $flutterPath @FlutterArgs
    if ($LASTEXITCODE -ne 0) { throw "Flutter fehlgeschlagen: $($FlutterArgs -join ' ')" }
}
Invoke-Flutter -FlutterArgs @('pub', 'get')
Invoke-Flutter -FlutterArgs @('analyze')
Invoke-Flutter -FlutterArgs @('test', '--concurrency=1')
New-Item -ItemType Directory -Path dist -Force | Out-Null
if ($Target -in @('All','Windows')) {
    Invoke-Flutter -FlutterArgs @('build', 'windows', '--release')
    New-Item -ItemType Directory -Path dist/Windows -Force | Out-Null
    Copy-Item -Path build/windows/x64/runner/Release/* -Destination dist/Windows -Recurse -Force
    $vswhere = Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (Test-Path -LiteralPath $vswhere) {
        $vsRoot = & $vswhere -latest -property installationPath
        $crt = Get-ChildItem -Path "$vsRoot/VC/Redist/MSVC/*/x64/Microsoft.VC143.CRT" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($crt) { Copy-Item -Path "$($crt.FullName)/*.dll" -Destination dist/Windows -Force }
    }
    Copy-Item -LiteralPath README.md -Destination dist/Windows/README.md -Force
    Copy-Item -LiteralPath assets/fonts/OFL.txt -Destination dist/Windows/DM-Sans-OFL.txt -Force
    New-Item -ItemType Directory -Path dist/Windows/artifacts/screenshots -Force | Out-Null
    Copy-Item -Path artifacts/screenshots/*.png -Destination dist/Windows/artifacts/screenshots -Force
    Compress-Archive -Path dist/Windows/* -DestinationPath dist/Mathe-Bud-E-Windows.zip -Force
}
if ($Target -in @('All','Android')) {
    Invoke-Flutter -FlutterArgs @('build', 'apk', '--release', '--no-shrink')
    Copy-Item -LiteralPath build/app/outputs/flutter-apk/app-release.apk -Destination dist/Mathe-Bud-E.apk -Force
}
Write-Host 'Fertig. Die App-Dateien liegen in dist/.'
