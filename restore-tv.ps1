# PowerShell script to restore Sony BRAVIA BF1 to original state
param(
    [string]$TvHost = "192.168.1.6"
)

$ErrorActionPreference = "Stop"
$env:TV_HOST = $TvHost
$py = Join-Path $PSScriptRoot "tools\venv\Scripts\python.exe"
$tv = Join-Path $PSScriptRoot "tools\tv.py"

Write-Host "Connecting to TV at $TvHost..."

$disabledPackages = @(
    "tv.samba.ssm",
    "com.sony.dtv.promos",
    "com.sony.dtv.sonyselect",
    "com.google.android.feedback",
    "com.sony.dtv.demosupport",
    "com.sony.dtv.demosystemsupport",
    "com.sony.dtv.multiscreendemo",
    "com.graymatrix.did",
    "com.crunchyroll.crunchyroid",
    "com.sonypicturescore",
    "com.google.android.play.games",
    "com.google.android.videos",
    "com.google.android.youtube.tvmusic",
    "com.vectorunit.purple.googleplay",
    "com.sony.gaus.updatecenter",
    "com.mediatek.tv.systemupdater",
    "com.google.android.tungsten.setupwraith",
    "com.google.android.apps.tv.launcherx",
    "com.google.android.apps.tv.dreamx"
)

Write-Host "Re-enabling all debloated packages..."
foreach ($pkg in $disabledPackages) {
    Write-Host "Enabling $pkg..."
    & $py $tv "pm enable --user 0 $pkg"
}

Write-Host "Restoring stock Google TV launcher as Home..."
& $py $tv "cmd package set-home-activity --user 0 com.google.android.apps.tv.launcherx/.home.HomeActivity"

Write-Host "Restoring default screensaver..."
& $py $tv "settings put secure screensaver_components com.google.android.apps.tv.dreamx/.DreamActivity"

Write-Host "Restoring opportunistic DNS..."
& $py $tv "settings put global private_dns_mode opportunistic"

Write-Host "Syncing disk and restarting Home..."
& $py $tv "sync"
& $py $tv "am start -W -a android.intent.action.MAIN -c android.intent.category.HOME"

Write-Host "Restore complete!"
