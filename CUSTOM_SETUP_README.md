# CleanYourTV — Sony BRAVIA BF1 Setup Summary & Guide

## Device Information
- **Model**: Sony BRAVIA BF1 (BRAVIA 2 II class, device `BRAVIA_BF1_4K_A`, MediaTek)
- **OS**: Android 12 (Google TV, API level 31)
- **Firmware Build**: `STT2.230811.001`
- **IP Address**: `192.168.1.6`
- **Wi-Fi Network**: `PPC135D5-5G`

---

## What Was Done

### 1. Full Backup
Before any changes were made, full system states and package lists were backed up into the `backup/` folder:
- `backup/packages_all.txt`
- `backup/packages_enabled.txt`
- `backup/packages_disabled.txt`
- `backup/getprop.txt`
- `backup/settings_system.txt`, `backup/settings_secure.txt`, `backup/settings_global.txt`

### 2. Debloated Packages (Disabled, Never Uninstalled)
The following manufacturer bloatware, tracking telemetry, and unused preinstalled apps were safely disabled for user 0:
- **Telemetry & Tracking**:
  - `tv.samba.ssm` (Samba TV ACR screen recognition & ad tracker)
  - `com.sony.dtv.promos` (Sony promotional content)
  - `com.sony.dtv.sonyselect` (Sony Select sponsored apps)
  - `com.google.android.feedback` (Google crash/feedback reporter)
- **Demo Mode**:
  - `com.sony.dtv.demosupport`
  - `com.sony.dtv.demosystemsupport`
  - `com.sony.dtv.multiscreendemo`
- **Unused Preinstalled Streaming & Media Apps**:
  - `com.graymatrix.did` (Zee5)
  - `com.crunchyroll.crunchyroid` (Crunchyroll)
  - `com.sonypicturescore` (Sony Pictures Core)
  - `com.google.android.play.games` (Google Play Games)
  - `com.google.android.videos` (Google Play Movies / Google TV)
  - `com.google.android.youtube.tvmusic` (YouTube Music)
  - `com.vectorunit.purple.googleplay` (Beach Buggy Racing preloaded game)
  - `com.sony.gaus.updatecenter` (Sony update center)
  - `com.mediatek.tv.systemupdater` (MediaTek system updater)
- **Stock Launcher & Setup Wizard Handover**:
  - `com.google.android.tungsten.setupwraith` (Setup wizard)
  - `com.google.android.apps.tv.launcherx` (Stock Google TV ad-filled launcher)
  - `com.google.android.apps.tv.dreamx` (Stock ambient screensaver replaced with clock screensaver)

### 3. Preserved Essential Apps & Services
Everything needed for your TV to function flawlessly remains active:
- **Streaming apps**: YouTube, Netflix, Amazon Prime Video, JioHotstar, Sony LIV, VLC Media Player.
- **Connectivity & Casting**: Chromecast built-in (`com.google.android.apps.mediashell`), Apple AirPlay (`com.sony.dtv.airplayapp`).
- **Voice Search**: Google Assistant (`com.google.android.katniss`), Sony Voice Search (`com.sony.dtv.voicesearch`).
- **Core TV System**: TV input & tuner framework (`com.mediatek.dtv.tvinput.*`, `com.sony.dtv.tvinput.dvbtuner`, `com.mediatek.tis`), Sony smart UI input menu (`com.sony.dtv.smartui`), Sony system service (`com.sony.dtv.sonysystemservice`), Google Play Store, Play Services, and Gboard.

### 4. Apple TV Style Custom Launcher (`com.gathin.tvhome`)
- **Pitch Black Background** (`#000000`) designed for OLED and high-contrast TVs.
- **5-Slot Dock**: YouTube, Netflix, Prime Video, JioHotstar, Sony LIV resting inside a translucent rounded glass band at the bottom.
- **Apple TV Focus Effects**:
  - Large type title above dock with dynamic ambient color glow sampled from the focused app's banner (e.g. red for YouTube & Netflix, blue for Prime Video, cyan/violet for JioHotstar).
  - Single fluid translucent glass highlight bouncing between tiles with spring physics.
- **Top Bar**:
  - Outfit open-source typeface with live time, greeting ("Good evening"), and date.
  - **Auto-Rotating System Resource Monitor Pill**:
    - Replaces the static inputs label in a single clean frosted glass pill.
    - Automatically cycles every **3 seconds** between:
      1. **RAM Consumption**: e.g., `RAM: 1.1 / 2.3 GB` with RAM module icon (`ic_ram.xml`).
      2. **Storage Consumption**: e.g., `Storage: 3.2 / 7.3 GB` with internal drive icon (`ic_storage.xml`).
      3. **CPU Consumption**: e.g., `CPU: 22%` with processor microchip icon (`ic_cpu.xml`).
    - **Interactive Click-to-Cycle**: Clicking or pressing **OK / Enter** on the pill immediately cycles to the next metric (RAM → Storage → CPU → RAM) and resets the 3-second auto-timer.
    - **HDMI / Input Source Switcher**: Long-pressing the pill opens the compact glass dropdown listing HDMI 1-4, AV, and Live TV.
  - **Dynamic Wi-Fi Signal Strength Pill**:
    - Displays the TV's real-time Wi-Fi signal strength (4-bar signal level from RSSI) instead of a generic icon.
    - Icon-only by default for a clean, minimalist Apple TV look.
    - Smoothly expands horizontally on hover or D-pad focus to display the active network SSID (`PPC135D5-5G`).
  - **Expandable Settings Pill**:
    - Icon-only by default with modern gear icon.
    - Smoothly expands horizontally on hover or D-pad focus to reveal the `Settings` label.
    - Click opens native Android TV Settings; long-press opens Launcher Settings.
- **Interactive Long-Press Action Menu**:
  Holding the **OK / Center** button (or remote **Menu** button) on any app tile opens a frosted glass popup with 3 actions:
  1. **App info**: Opens the native Android TV system application details page for that app (force stop, clear storage, manage permissions, uninstall updates).
  2. **Move**: Enters free D-pad repositioning mode. The tile elevates with an ambient glow and can be moved left, right, up, or down across the dock and grid. Pressing **Enter / OK** drops the app into the target slot and immediately exits move mode.
  3. **Uninstall**: Launches the native Android uninstaller dialog (`com.android.packageinstaller.UninstallerActivity`) with a confirmation prompt ("Do you want to uninstall this app? OK / Cancel").
- **Navigation**:
  - D-pad up from dock lands on the top bar pills.
  - D-pad down scrolls up the remaining apps in an identical 5-column grid.
  - Previous focused tile position is always remembered.

### 5. AdGuard Private DNS
- Set to `dns.adguard-dns.com` (`hostname` mode).
- Blocks network-level advertising, trackers, and malicious domains across apps.
- *Note*: Stream-injected YouTube video ads are served from YouTube's own video domains and cannot be blocked via DNS alone.

---

## How-To Guide

### How to Re-enable Any Disabled App
If you ever want to re-enable a specific app (e.g. Sony Pictures Core or Zee5), run:
```powershell
$env:TV_HOST = "192.168.1.6"
python tools\tv.py "pm enable --user 0 <package_name>"
```
For example, to re-enable Zee5:
```powershell
python tools\tv.py "pm enable --user 0 com.graymatrix.did"
```

### How to Change the Dock Order or Number of Slots
1. Open `launcher\app\src\main\res\values\config.xml`.
2. Locate `<string-array name="dock_apps">` and reorder or add package names.
3. If changing the number of slots, update `<integer name="columns">` to match.
4. Run the build and install script:
   ```powershell
   .\build-and-install-launcher.ps1
   ```

### How to Add or Change Wallpapers
You can push custom wallpapers or themes at any time without rebuilding the APK using the theme tool:
```powershell
powershell -ExecutionPolicy Bypass -File tools\theme.ps1 -TvHost 192.168.1.6 themes\glass
```
Or place a 1920x1080 image named `wallpaper.jpg` inside your custom theme folder and apply it.

### How to Revert Private DNS
If you experience any connectivity issue with Private DNS or want to switch back to automatic:
```powershell
$env:TV_HOST = "192.168.1.6"
python tools\tv.py "settings put global private_dns_mode opportunistic"
```

### How to Fully Restore the TV to Stock
To undo all debloating and return to the stock Google TV launcher:
```powershell
powershell -ExecutionPolicy Bypass -File .\restore-tv.ps1 -TvHost 192.168.1.6
```

---

## Securing Your TV (Closing ADB Debugging)
Leaving port 5555 open allows anyone on your local network to connect. Now that setup is complete:
1. On your Sony TV remote, press **Settings** (gear icon) → **System** → **Developer options**.
2. Switch **USB debugging** to **OFF**.
3. Select **Revoke USB debugging authorizations** and confirm.
4. Restart the TV once.
5. Verify from your computer that ADB is closed:
   ```powershell
   python tools\adb-closed.py 192.168.1.6
   ```
   The script must report `refused` or `closed`.
