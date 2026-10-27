# PowerShell script to rebuild and install the launcher on the TV
param(
    [string]$TvHost = "192.168.1.6"
)

$ErrorActionPreference = "Stop"
$env:TV_HOST = $TvHost
$env:ANDROID_HOME = "C:\Users\annam\AppData\Local\Android\Sdk"
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

$repoRoot = $PSScriptRoot
$launcherDir = Join-Path $repoRoot "launcher"
$py = Join-Path $repoRoot "tools\venv\Scripts\python.exe"
$b64 = Join-Path $repoRoot "tools\b64push.py"
$tv = Join-Path $repoRoot "tools\tv.py"

Write-Host "Building launcher APK with Gradle..."
Push-Location $launcherDir
try {
    .\gradlew.bat assembleRelease -q --console=plain
} finally {
    Pop-Location
}

$apk = Join-Path $launcherDir "app\build\outputs\apk\release\app-release.apk"
if (-not (Test-Path $apk)) {
    throw "APK build output not found at $apk"
}

Write-Host "Uploading launcher APK to TV..."
& $py $b64 $apk /data/local/tmp/tvhome.apk

Write-Host "Installing launcher on TV..."
& $py $tv "pm install -r /data/local/tmp/tvhome.apk; rm -f /data/local/tmp/tvhome.apk"

Write-Host "Setting launcher as default Home..."
& $py $tv "cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity"
& $py $tv "pm grant com.gathin.tvhome android.permission.ACCESS_FINE_LOCATION"
& $py $tv "cmd package compile -m speed -f com.gathin.tvhome"

Write-Host "Starting launcher..."
& $py $tv "am start -W -a android.intent.action.MAIN -c android.intent.category.HOME -n com.gathin.tvhome/.MainActivity"

Write-Host "Launcher installed and running successfully!"
