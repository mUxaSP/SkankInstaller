<#
.SYNOPSIS
    SkankInstaller ver. 1.0-Alpha (Created By mUxa / u/Motor-Statement-8615)

.DESCRIPTION
    Installs SkankPhone (Apple internal build, Alpine 1A420 dump) on the iPhone 2G,
    based on the instructions from r/Apple_Internal.

    Languages: English (default), Russian, Deutsch, Espanol, Francais.
    All files must be provided MANUALLY by the user (no auto-downloads).

    ALPHA SOFTWARE: the user is fully responsible for any damage to the device.
    Educational and archival purposes only.

    Run via SkankInstaller.cmd
#>

[CmdletBinding()]
param(
    # Phone IP (can be entered later in the menu)
    [string]$IP,
    # Root password on the phone (default after jailbreak: alpine)
    [string]$Password = "alpine",
    # Working directory for user-provided files
    [string]$WorkDir = "",
    # Language override: en | ru | de | es | fr
    [ValidateSet("", "en", "ru", "de", "es", "fr")][string]$Lang = ""
)

# ============================================================
#  Global settings
# ============================================================
$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

if ([string]::IsNullOrWhiteSpace($WorkDir)) {
    if ($PSScriptRoot) { $WorkDir = Join-Path $PSScriptRoot "workspace" }
    else               { $WorkDir = Join-Path (Get-Location).Path "workspace" }
}

$Script:PlinkPath = Join-Path $WorkDir "tools\plink.exe"
$Script:PscpPath  = Join-Path $WorkDir "tools\pscp.exe"
$Script:StateFile = Join-Path $WorkDir "skankphone-files.json"
$Script:CfgFile   = Join-Path $WorkDir "config.json"

# --- user-provided files (NO auto-download) ---
$AlpineZipName = "1.0 Alpine 1A420 (iPhone 2G).zip"
$ZipMd5        = "79fbde0265e4ce508041319d0f4f3347"
$JbFiles       = @("Antares_Windows_x64.zip", "PXLInstaller_Windows_x64.zip", "zadig.exe", "PXLpak.zip")

# --- links (shown in Help and README.txt; user downloads manually) ---
$LinkThread  = "https://www.reddit.com/r/Apple_Internal/comments/m76sce/"
$LinkAntares = "https://github.com/theiphoneos1project/Antares/releases"
$LinkPXL     = "https://github.com/theiphoneos1project/PXLInstaller/releases"
$LinkZadig   = "https://github.com/pbatard/libwdi/releases"
$LinkPXLpak  = "http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip"
$LinkPutty   = "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe"

# --- paths on the phone ---
$DevMedia      = "/var/mobile/Media/spk.tgz"
$DevTmpExtract = "/var/mobile/Media/spk_extract"
$DevAI         = "/AppleInternal"
$DevPF         = "/System/Library/PrivateFrameworks"
$DevApps       = "/Applications/SkankPhone.app"
$DevManifest   = "/AppleInternal/.spk_pf_manifest"
$DevDaemon     = "/System/Library/LaunchDaemons/com.apple.SkankPhone.plist"

# ============================================================
#  Localization (EN default, RU, DE, ES, FR)
# ============================================================

$Script:LangTables = @{
en = @{
    'banner.title' =  "SKANKINSTALLER  ver. 1.0-Alpha"
    'banner.author' =  "Created By mUxa (u/Motor-Statement-8615)"
    'lang.saved' =  "Language saved: {0}"
    'status.files.ready' =  "SkankPhone files : ready"
    'status.files.no' =  "SkankPhone files : missing"
    'status.ssh.ready' =  "SSH tools        : ready"
    'status.ssh.no' =  "SSH tools        : missing"
    'status.ip' =  "Phone IP         : {0}"
    'status.ip.none' =  "Phone IP         : not set"
    'menu.1' =  "1 - Verify/prepare SkankPhone files (Alpine 1A420)"
    'menu.2' =  "2 - Check jailbreak tools + instructions (Antares/PXL)"
    'menu.3' =  "3 - Connect to iPhone and check (iOS version, space)"
    'menu.4' =  "4 - INSTALL SkankPhone on the phone"
    'menu.5' =  "5 - Autoboot SkankPhone at startup (thread option)"
    'menu.6' =  "6 - Uninstall SkankPhone (full revert)"
    'menu.7' =  "7 - Free up space on the phone (clean /Applications)"
    'menu.8' =  "8 - Help and links"
    'menu.0' =  "0 - Exit"
    'prompt.choose' =  "  Choose an option"
    'prompt.enter' =  "  Enter - back to menu"
    'res.ok' =  "  [OK] Step completed."
    'res.fail' =  "  [!] Step not completed."
    's1.title' =  "STEP 1. SkankPhone (Alpine 1A420) - verify and prepare files"
    's1.needtar' =  "tar.exe is required (Windows 10 1803+). Update Windows."
    's1.zip.missing' =  "File not found: {0}"
    's1.zip.hint' =  "Download it yourself and put it into this folder. Link in Help (menu 8)."
    's1.zip.found' =  "Archive found: {0} ({1:N1} MB)"
    's1.md5' =  "Archive MD5: {0}"
    's1.md5.ok' =  "MD5 matches - the archive is intact."
    's1.md5.bad' =  "WARNING: MD5 mismatch! The archive may be corrupted."
    's1.md5.cont' =  "  Continue anyway? (y/N)"
    's1.unpackzip' =  "Unpacking zip..."
    's1.unpackzip.err' =  "Zip unpack error: {0}"
    's1.bz2.notfound' =  "prototype-fw.tar.bz2 not found in the zip!"
    's1.reading' =  "Reading prototype-fw.tar.bz2 contents..."
    's1.read.err' =  "Cannot read the archive: {0}"
    's1.entries.notfound' =  "Expected paths not found in the dump (AppleInternal/SkankPhone.app/PrivateFrameworks)!"
    's1.ai' =  "AppleInternal (tar)      : {0}"
    's1.pf' =  "PrivateFrameworks (tar)  : {0}"
    's1.plist' =  "Autoboot plist           : {0}"
    's1.plist.no' =  "Autoboot plist           : not found"
    's1.size.ai' =  "AppleInternal size       : {0:N1} MB"
    's1.size.pf' =  "PrivateFrameworks size   : {0:N1} MB"
    's1.done' =  "Done! Files are prepared for installation."
    's2.title' =  "STEP 2. Jailbreak tools check (Antares + PXLInstaller)"
    's2.expect' =  "These files must be placed MANUALLY into:"
    's2.missing' =  "MISSING (download them yourself; links in Help/menu 8 and README.txt):"
    's2.present' =  "Present:"
    's2.unpack' =  "Unpacking: {0}"
    's2.unpack.err' =  "Unpack error: {0}"
    's2.pxl' =  "PXL extracted: {0}"
    's2.opened' =  "Folder opened in Explorer: {0}"
    's2.done' =  "All tools ready. The jailbreak instructions follow below."
    'jb.1' =  "JAILBREAK INSTRUCTIONS (Antares, iPhone OS 1.0-1.1.5):"
    'jb.2' =  "1. Connect the iPhone via USB. The tools folder has opened."
    'jb.3' =  "2. Run zadig.exe: Options -> List All Devices, pick the iPhone (usually 'Apple Mobile Device (Interface 1)'). Driver: libusbK -> Replace Driver. Reboot if asked."
    'jb.4' =  "3. Run antares-gui.exe -> Tools -> Enter Recovery."
    'jb.5' =  "4. In Zadig pick the device in Recovery (e.g. '... (IF0) (Interface 0)'), install libusbK again -> Replace Driver. Reboot the PC."
    'jb.6' =  "5. Open antares-gui.exe and press Jailbreak. After the reboot the phone is jailbroken."
    'jb.7' =  "6. Run pxlinstaller-gui.exe: Install Application, and install from jailbreak\pxl-tweaks:"
    'jb.8' =  "    - BSD Subsystem (*.pxl)  - tar/cp utilities (REQUIRED)"
    'jb.9' =  "    - Dropbear (*.pxl)       - SSH server (REQUIRED)"
    'jb.10' =  "   Root password after the jailbreak: alpine"
    'jb.11' =  "After the jailbreak and PXL install - come back and choose STEP 3."
    'c.title' =  "Connecting to the iPhone 2G via SSH"
    'c.hint1' =  "Find the phone IP: Settings -> Wi-Fi -> blue arrow near the network -> IP Address."
    'c.ip.prompt' =  "  Enter phone IP (e.g. 192.168.1.42; 'q' - cancel)"
    'c.target' =  "Target: root@{0} (password: {1})"
    'c.checking' =  "Checking connection (first connection stores the host key)..."
    'c.nolink' =  "NO CONNECTION to the phone. Check:"
    'c.chk1' =  "   - the phone is in the same Wi-Fi network as the PC;"
    'c.chk2' =  "   - SSH is installed (Dropbear PXL from the jailbreak step);"
    'c.chk3' =  "   - the IP is correct (the phone screen may be asleep - wake it)."
    'c.resp' =  "Response: {0}"
    'c.linkok' =  "SSH connection OK."
    'c.ver' =  "iPhone OS version: {0}"
    'c.stop1' =  "STOP! Do NOT install SkankPhone on genuine iPhone OS 1.0.x - the phone can be"
    'c.stop2' =  "bricked (direct warning from the thread author). Update to 1.1.4/1.1.5."
    'c.edited1' =  "WARNING: SystemVersion.plist shows 1.0, but the build does not match a genuine"
    'c.edited2' =  "1.0.x - the plist was probably edited manually. Continuing."
    'c.other' =  "WARNING: the method is tested on iPhone OS 1.1.x, you have {0}."
    'c.risk' =  "  Continue at your own risk? (y/N)"
    'c.free' =  "Free space on the system partition: {0:N1} MB"
    'c.note1' =  "Exact space math is done during install (only missing frameworks are copied)."
    'c.note2' =  "If space runs out, the installer will offer to clean /Applications (menu 7)."
    's4.title' =  "STEP 4. Installing SkankPhone on the iPhone"
    's4.nostate' =  "Run STEP 1 first (SkankPhone files are not prepared)."
    's4.bz2.gone' =  "prototype-fw.tar.bz2 not found - run STEP 1 again."
    's4.bz2.found' =  "Archive found at the new path: {0}"
    's4.building' =  "Building the package (AppleInternal + PrivateFrameworks)..."
    's4.builderr' =  "Package build error: {0}"
    's4.pkg' =  "Package: {0:N1} MB"
    's4.probing' =  "Comparing frameworks with the phone..."
    's4.stats' =  "Frameworks in package: {0}; already on phone: {1}; to add: {2}"
    's4.adding' =  "To add: {0}"
    's4.need' =  "Space needed on the system partition: ~{0} MB"
    's4.free' =  "Free: {0:N1} MB"
    's4.little' =  "LOW SPACE: {0:N1} MB free, ~{1} MB needed."
    's4.little2' =  "Easiest fix - delete stock apps from /Applications (restored by reflashing; the thread author did this)."
    's4.cleanprompt' =  "  Clean /Applications right now? (Y/n)"
    's4.stillbad' =  "Still not enough space. Run menu item 7 again and delete more apps,"
    's4.stillbad2' =  "or reflash the phone to clean 1.1.4 - it frees the most."
    's4.declined' =  "Install cancelled. Free up space (menu item 7) and try again."
    's4.plan1' =  "Will be done (per the thread instructions):"
    's4.plan2' =  "   - copy /AppleInternal to the phone;"
    's4.plan3' =  "   - add ONLY missing frameworks to /System/Library/PrivateFrameworks;"
    's4.plan4' =  "   - create the symlink /Applications/SkankPhone.app;"
    's4.plan5' =  "   - set permissions on the binary (chmod +rwx);"
    's4.plan6' =  "   - restart SpringBoard."
    's4.go' =  "  Continue? (y/N)"
    's4.uploading' =  "Uploading the package to the phone (Wi-Fi - do not let the phone sleep!)..."
    's4.fallback' =  "pscp failed, trying the fallback (cat over SSH)..."
    's4.uploaderr' =  "Upload failed: {0}"
    's4.uploaded' =  "Package uploaded."
    's4.installing' =  "Installing on the phone..."
    's4.scripterr' =  "Phone-side error. See the output above and the log."
    's4.respring' =  "Restarting SpringBoard..."
    's4.done1' =  "DONE! The SkankPhone icon should appear on the home screen."
    's4.done2' =  "If the screen/backlight/touch turned off - press the Power button twice."
    's4.done3' =  "Want SkankPhone at boot - choose menu item 5."
    's5.title' =  "STEP 5. SkankPhone autoboot at startup (OPTION from the thread)"
    's5.warn' =  "WARNING: after this the phone boots straight into SkankPhone."
    's5.warn2' =  "Revert: menu item 6 removes this plist too."
    's5.prompt' =  "  Enable autoboot? (y/N)"
    's5.noplist' =  "com.apple.SkankPhone.plist not found in /AppleInternal - autoboot not set."
    's5.ok' =  "Done! Reboot the phone - it starts into SkankPhone."
    's5.reboot' =  "  Reboot now? (y/N)"
    's5.err' =  "Could not run on the phone (see output above)."
    's6.title' =  "STEP 6. Uninstall SkankPhone (full revert)"
    's6.plan1' =  "Will be removed:"
    's6.plan2' =  "   - the symlink /Applications/SkankPhone.app;"
    's6.plan3' =  "   - /AppleInternal entirely;"
    's6.plan4' =  "   - frameworks ADDED by the installer (via .spk_pf_manifest);"
    's6.plan5' =  "   - /System/Library/LaunchDaemons/com.apple.SkankPhone.plist (if present)."
    's6.prompt' =  "  Continue? (y/N)"
    's6.done' =  "SkankPhone removed. Restarting SpringBoard..."
    's6.err' =  "Uninstall error (see output above)."
    'f.title' =  "Freeing space: removing apps from /Applications"
    'f.count' =  "Entries found in /Applications: {0}"
    'f.row.mb' =  "    {0,8:N1} MB  {1}"
    'f.row.unk' =  "    (size unknown)  {0}"
    'f.total' =  "    Total: ~{0:N1} MB"
    'f.safe1' =  "Stock apps are safe to delete - they are restored by reflashing to 1.1.4."
    'f.safe2' =  "Dropbear and BSD Subsystem live in /usr and will NOT be affected."
    'f.safe3' =  "Apps installed via Installer.app - list them separately if you want to keep them."
    'f.prompt1' =  "  Enter app names separated by commas (as in the list above),"
    'f.prompt2' =  "  'all' - delete EVERYTHING from /Applications, Enter - cancel."
    'f.prompt3' =  "  What to delete?"
    'f.cancel' =  "Cancelled."
    'f.skip' =  "  Skipping (not found in /Applications): {0}"
    'f.nothing' =  "Nothing to delete."
    'f.removed' =  "Removed entries: {0}"
    'f.freenow' =  "Free space on the system partition now: {0:N1} MB"
    'f.listerr' =  "Could not get the app list from the phone. See the log."
    'h.title' =  "HELP"
    'h.link1' =  "Original thread with the instructions:"
    'h.link2' =  "SkankPhone files (how to find them):"
    'h.dump1' =  "Search Google for: site:archive.org switchboard"
    'h.dump2' =  "Look for a file titled `"Apple iOS SwitchBoard Firmwares (Common).`""
    'h.dump3' =  "Inside, you will find a zip archive named `"Alpine 1A420 (iPhone 2G).zip.`""
    'h.dump4' =  "Download it and open the `"prototype-fw.tar.bz2`" file; it contains"
    'h.dump5' =  "all the files required to follow this guide."
    'h.link3' =  "Antares jailbreak guide:"
    'h.link4' =  "Manual downloads (put files into the folders shown):"
    'h.order' =  "Steps:"
    'h.order1' =  "   1. STEP 1 - put the Alpine 1A420 zip into workspace\downloads and verify (menu 1);"
    'h.order2' =  "   2. STEP 2 - put the tools into workspace\jailbreak, jailbreak with Antares"
    'h.order3' =  "        and install BSD Subsystem + Dropbear via PXLInstaller;"
    'h.order4' =  "   3. STEP 3 - connect via SSH (root / alpine);"
    'h.order5' =  "   4. STEP 4 - install SkankPhone;"
    'h.order6' =  "   5. (optional) STEP 5 - SkankPhone autoboot;"
    'h.order7' =  "   6. STEP 6 - full revert. Menu item 7 - free up space."
    'h.warn' =  "IMPORTANT WARNINGS (from the thread):"
    'h.warn1' =  "   - do NOT install on genuine iPhone OS 1.0.x - the phone can be bricked;"
    'h.warn2' =  "   - do not interrupt the Wi-Fi upload (do not let the phone sleep);"
    'h.warn3' =  "   - if the backlight/touch/screen turned off - press Power twice;"
    'h.warn4' =  "   - a permanent brick is nearly impossible: iTunes always restores 1.x."
    'h.alpha' =  "ALPHA NOTICE: this software is in alpha and may contain bugs. YOU are fully"
    'h.alpha2' =  "responsible for any damage to your device. Educational/archival use only."
    'h.back' =  "  Enter - back to menu"
    'm.putty.missing' =  "PuTTY not found. Put plink.exe and pscp.exe into:"
    'm.putty.link' =  "Download: https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe and pscp.exe"
}
ru = @{
    'banner.title' =  "SKANKINSTALLER  ver. 1.0-Alpha"
    'banner.author' =  "Created By mUxa (u/Motor-Statement-8615)"
    'lang.saved' =  "Язык сохранён: {0}"
    'status.files.ready' =  "Файлы SkankPhone: готовы"
    'status.files.no' =  "Файлы SkankPhone: нет"
    'status.ssh.ready' =  "SSH-инструменты : готовы"
    'status.ssh.no' =  "SSH-инструменты : нет"
    'status.ip' =  "IP телефона     : {0}"
    'status.ip.none' =  "IP телефона     : не задан"
    'menu.1' =  "1 - Проверить/подготовить файлы SkankPhone (Alpine 1A420)"
    'menu.2' =  "2 - Проверить инструменты джейлбрейка + инструкция (Antares/PXL)"
    'menu.3' =  "3 - Подключиться к iPhone и проверить (версия iOS, место)"
    'menu.4' =  "4 - УСТАНОВИТЬ SkankPhone на телефон"
    'menu.5' =  "5 - Автозапуск SkankPhone при загрузке (опция из треда)"
    'menu.6' =  "6 - Удалить SkankPhone (полный откат)"
    'menu.7' =  "7 - Освободить место на телефоне (очистка /Applications)"
    'menu.8' =  "8 - Справка и ссылки"
    'menu.0' =  "0 - Выход"
    'prompt.choose' =  "  Выбери пункт"
    'prompt.enter' =  "  Enter — в меню"
    'res.ok' =  "  [OK] Шаг выполнен."
    'res.fail' =  "  [!] Шаг не завершён."
    's1.title' =  "ШАГ 1. SkankPhone (Alpine 1A420) — проверка и подготовка файлов"
    's1.needtar' =  "Нужен tar.exe (есть в Windows 10 1803+). Обнови Windows."
    's1.zip.missing' =  "Файл не найден: {0}"
    's1.zip.hint' =  "Скачай его сам и положи в эту папку. Ссылка в Справке (пункт 8)."
    's1.zip.found' =  "Архив найден: {0} ({1:N1} МБ)"
    's1.md5' =  "MD5 архива: {0}"
    's1.md5.ok' =  "MD5 совпадает — архив целый."
    's1.md5.bad' =  "ПРЕДУПРЕЖДЕНИЕ: MD5 не совпал! Архив мог побиться."
    's1.md5.cont' =  "  Продолжить всё равно? (y/N)"
    's1.unpackzip' =  "Распаковываю zip..."
    's1.unpackzip.err' =  "Ошибка распаковки zip: {0}"
    's1.bz2.notfound' =  "В zip не найден prototype-fw.tar.bz2!"
    's1.reading' =  "Читаю содержимое prototype-fw.tar.bz2..."
    's1.read.err' =  "Не удалось прочитать архив: {0}"
    's1.entries.notfound' =  "В дампе не найдены ожидаемые пути (AppleInternal/SkankPhone.app/PrivateFrameworks)!"
    's1.ai' =  "AppleInternal (tar)      : {0}"
    's1.pf' =  "PrivateFrameworks (tar)  : {0}"
    's1.plist' =  "Плейлист автозапуска     : {0}"
    's1.plist.no' =  "Плейлист автозапуска     : не найден"
    's1.size.ai' =  "Размер AppleInternal     : {0:N1} МБ"
    's1.size.pf' =  "Размер PrivateFrameworks : {0:N1} МБ"
    's1.done' =  "Готово! Файлы подготовлены к установке."
    's2.title' =  "ШАГ 2. Проверка инструментов джейлбрейка (Antares + PXLInstaller)"
    's2.expect' =  "Эти файлы нужно положить ВРУЧНУЮ в папку:"
    's2.missing' =  "ОТСУТСТВУЮТ (скачай сам; ссылки в Справке/пункт 8 и README.txt):"
    's2.present' =  "Есть:"
    's2.unpack' =  "Распаковываю: {0}"
    's2.unpack.err' =  "Ошибка распаковки: {0}"
    's2.pxl' =  "PXL извлечён: {0}"
    's2.opened' =  "Папка открыта в проводнике: {0}"
    's2.done' =  "Все инструменты на месте. Ниже — инструкция джейлбрейка."
    'jb.1' =  "ИНСТРУКЦИЯ ДЖЕЙЛБРЕЙКА (Antares, iPhone OS 1.0–1.1.5):"
    'jb.2' =  "1. Подключи iPhone по USB. Папка с инструментами уже открылась."
    'jb.3' =  "2. Запусти zadig.exe: Options -> List All Devices, выбери iPhone (обычно 'Apple Mobile Device (Interface 1)'). Драйвер: libusbK -> Replace Driver. Если просит — перезагрузись."
    'jb.4' =  "3. Запусти antares-gui.exe -> Tools -> Enter Recovery."
    'jb.5' =  "4. В Zadig выбери устройство в Recovery (пример: '... (IF0) (Interface 0)'), снова ставь libusbK -> Replace Driver. Перезагрузи ПК."
    'jb.6' =  "5. Открой antares-gui.exe и нажми Jailbreak. После перезагрузки телефон джейлбрейкнут."
    'jb.7' =  "6. Запусти pxlinstaller-gui.exe: Install Application, и поставь из jailbreak\pxl-tweaks:"
    'jb.8' =  "    - BSD Subsystem (*.pxl)  — утилиты tar/cp (ОБЯЗАТЕЛЬНО)"
    'jb.9' =  "    - Dropbear (*.pxl)       — SSH-сервер (ОБЯЗАТЕЛЬНО)"
    'jb.10' =  "   Пароль root после джейлбрейка: alpine"
    'jb.11' =  "После джейлбрейка и установки PXL — возвращайся и выбирай ШАГ 3."
    'c.title' =  "Подключение к iPhone 2G по SSH"
    'c.hint1' =  "Найди IP телефона: Настройки -> Wi-Fi -> синяя стрелка рядом с сетью -> IP-адрес."
    'c.ip.prompt' =  "  Введи IP телефона (например 192.168.1.42; 'q' — отмена)"
    'c.target' =  "Цель: root@{0} (пароль: {1})"
    'c.checking' =  "Проверяю связь (первое подключение запоминает ключ хоста)..."
    'c.nolink' =  "НЕТ СВЯЗИ с телефоном. Проверь:"
    'c.chk1' =  "   - телефон в одной Wi-Fi сети с ПК;"
    'c.chk2' =  "   - SSH установлен (Dropbear PXL из шага с джейлбрейком);"
    'c.chk3' =  "   - IP правильный (экран телефона может спать — разбуди его)."
    'c.resp' =  "Ответ: {0}"
    'c.linkok' =  "SSH-связь есть."
    'c.ver' =  "Версия iPhone OS: {0}"
    'c.stop1' =  "СТОП! На подлинную iPhone OS 1.0.x устанавливать SkankPhone НЕЛЬЗЯ — телефон"
    'c.stop2' =  "можно окирпичить (прямое предупреждение автора треда). Обновись до 1.1.4/1.1.5."
    'c.edited1' =  "ВНИМАНИЕ: в SystemVersion.plist версия 1.0, но сборка не соответствует подлинной"
    'c.edited2' =  "1.0.x — похоже, plist правили вручную. Продолжаю."
    'c.other' =  "ВНИМАНИЕ: метод проверен на iPhone OS 1.1.x, у тебя {0}."
    'c.risk' =  "  Продолжить на свой страх и риск? (y/N)"
    'c.free' =  "Свободно на системном разделе: {0:N1} МБ"
    'c.note1' =  "Точный расчёт места — при установке (копируются только отсутствующие фреймворки)."
    'c.note2' =  "Если места не хватит — установщик сам предложит очистить /Applications (пункт 7)."
    's4.title' =  "ШАГ 4. Установка SkankPhone на iPhone"
    's4.nostate' =  "Сначала выполни ШАГ 1 (файлы SkankPhone не подготовлены)."
    's4.bz2.gone' =  "prototype-fw.tar.bz2 не найден — запусти ШАГ 1 заново."
    's4.bz2.found' =  "Архив найден по новому пути: {0}"
    's4.building' =  "Собираю пакет (AppleInternal + PrivateFrameworks)..."
    's4.builderr' =  "Ошибка сборки пакета: {0}"
    's4.pkg' =  "Пакет: {0:N1} МБ"
    's4.probing' =  "Сверяю фреймворки с телефоном..."
    's4.stats' =  "Фреймворков в пакете: {0}; уже есть на телефоне: {1}; добавить: {2}"
    's4.adding' =  "Добавляем: {0}"
    's4.need' =  "Нужно места на системном разделе: ~{0} МБ"
    's4.free' =  "Свободно: {0:N1} МБ"
    's4.little' =  "МЕСТА МАЛО: свободно {0:N1} МБ, нужно ~{1} МБ."
    's4.little2' =  "Проще всего — удалить стоковые приложения из /Applications (восстанавливаются перепрошивкой; так делал автор треда)."
    's4.cleanprompt' =  "  Очистить /Applications прямо сейчас? (Y/n)"
    's4.stillbad' =  "Места всё ещё мало. Запусти пункт 7 ещё раз и удали больше приложений,"
    's4.stillbad2' =  "либо перепрошей телефон на чистую 1.1.4 — это освободит больше всего."
    's4.declined' =  "Установка отменена. Освободи место (пункт 7 в меню) и попробуй снова."
    's4.plan1' =  "Будет сделано (по инструкции из треда):"
    's4.plan2' =  "   - скопировать /AppleInternal на телефон;"
    's4.plan3' =  "   - добавить ТОЛЬКО отсутствующие фреймворки в /System/Library/PrivateFrameworks;"
    's4.plan4' =  "   - создать симлинк /Applications/SkankPhone.app;"
    's4.plan5' =  "   - выставить права на бинарник (chmod +rwx);"
    's4.plan6' =  "   - перезапустить SpringBoard."
    's4.go' =  "  Продолжить? (y/N)"
    's4.uploading' =  "Загружаю пакет на телефон (Wi-Fi, не давай телефону уснуть!)..."
    's4.fallback' =  "pscp не сработал, пробую резервный способ (cat по SSH)..."
    's4.uploaderr' =  "Не удалось загрузить пакет на телефон: {0}"
    's4.uploaded' =  "Пакет загружен."
    's4.installing' =  "Устанавливаю на телефоне..."
    's4.scripterr' =  "Ошибка выполнения на телефоне. Смотри вывод выше и лог."
    's4.respring' =  "Перезапускаю SpringBoard..."
    's4.done1' =  "ГОТОВО! Иконка SkankPhone должна появиться на столе (SpringBoard)."
    's4.done2' =  "Если экран/подсветка/тач отключились — дважды нажми кнопку Power."
    's4.done3' =  "Хочешь автозапуск SkankPhone при загрузке — выбери пункт 5 в меню."
    's5.title' =  "ШАГ 5. Автозапуск SkankPhone при загрузке (ОПЦИЯ из треда)"
    's5.warn' =  "ВНИМАНИЕ: после этого телефон будет грузиться сразу в SkankPhone."
    's5.warn2' =  "Откат: пункт меню 6 удалит и этот плейлист тоже."
    's5.prompt' =  "  Включить автозапуск? (y/N)"
    's5.noplist' =  "Плейлист com.apple.SkankPhone.plist не найден в /AppleInternal — автозапуск не настроен."
    's5.ok' =  "Готово! Перезагрузи телефон — он стартует в SkankPhone."
    's5.reboot' =  "  Перезагрузить сейчас? (y/N)"
    's5.err' =  "Не получилось выполнить на телефоне (см. вывод выше)."
    's6.title' =  "ШАГ 6. Удаление SkankPhone и откат всех изменений"
    's6.plan1' =  "Будет удалено:"
    's6.plan2' =  "   - симлинк /Applications/SkankPhone.app;"
    's6.plan3' =  "   - /AppleInternal целиком;"
    's6.plan4' =  "   - фреймворки, которые ДОБАВЛЯЛ установщик (по манифесту .spk_pf_manifest);"
    's6.plan5' =  "   - /System/Library/LaunchDaemons/com.apple.SkankPhone.plist (если есть)."
    's6.prompt' =  "  Продолжить? (y/N)"
    's6.done' =  "SkankPhone удалён. Перезапускаю SpringBoard..."
    's6.err' =  "Ошибка при удалении (см. вывод выше)."
    'f.title' =  "Освобождение места: удаление приложений из /Applications"
    'f.count' =  "В /Applications найдено записей: {0}"
    'f.row.mb' =  "    {0,8:N1} МБ  {1}"
    'f.row.unk' =  "    (размер неизвестен)  {0}"
    'f.total' =  "    Всего: ~{0:N1} МБ"
    'f.safe1' =  "Стоковые приложения безопасно удалять — они восстанавливаются перепрошивкой на 1.1.4."
    'f.safe2' =  "Dropbear и BSD Subsystem живут в /usr и не пострадают."
    'f.safe3' =  "Приложения из Installer.app — укажи их отдельно, если хочешь сохранить."
    'f.prompt1' =  "  Введи имена приложений через запятую (как в списке выше),"
    'f.prompt2' =  "  'all' — удалить ВСЁ из /Applications, Enter — отмена."
    'f.prompt3' =  "  Что удалить?"
    'f.cancel' =  "Отменено."
    'f.skip' =  "  Пропускаю (не найдено в /Applications): {0}"
    'f.nothing' =  "Нечего удалять."
    'f.removed' =  "Удалено записей: {0}"
    'f.freenow' =  "Свободно на системном разделе теперь: {0:N1} МБ"
    'f.listerr' =  "Не удалось получить список приложений с телефона. Смотри лог."
    'h.title' =  "СПРАВКА"
    'h.link1' =  "Оригинальная инструкция (тред):"
    'h.link2' =  "Файлы SkankPhone (как их найти):"
    'h.dump1' =  "Ищи в Google: site:archive.org switchboard"
    'h.dump2' =  "Найди файл `"Apple iOS SwitchBoard Firmwares (Common)`"."
    'h.dump3' =  "Внутри будет zip-архив `"Alpine 1A420 (iPhone 2G).zip`"."
    'h.dump4' =  "Скачай его и открой файл prototype-fw.tar.bz2 —"
    'h.dump5' =  "в нём все файлы, нужные для этого гайда."
    'h.link3' =  "Джейлбрейк Antares (гайд):"
    'h.link4' =  "Ручные загрузки (положи файлы в указанные папки):"
    'h.order' =  "Порядок действий:"
    'h.order1' =  "   1. ШАГ 1 — положи zip Alpine 1A420 в workspace\downloads и проверь (пункт 1);"
    'h.order2' =  "   2. ШАГ 2 — положи инструменты в workspace\jailbreak, сделай джейлбрейк (Antares)"
    'h.order3' =  "        и поставь BSD Subsystem + Dropbear через PXLInstaller;"
    'h.order4' =  "   3. ШАГ 3 — подключись по SSH (root / alpine);"
    'h.order5' =  "   4. ШАГ 4 — установи SkankPhone;"
    'h.order6' =  "   5. (опция) ШАГ 5 — автозапуск SkankPhone;"
    'h.order7' =  "   6. ШАГ 6 — полный откат. Пункт 7 меню — освободить место."
    'h.warn' =  "ВАЖНЫЕ ПРЕДУПРЕЖДЕНИЯ (из треда):"
    'h.warn1' =  "   - НЕ устанавливать на подлинную iPhone OS 1.0.x — можно окирпичить;"
    'h.warn2' =  "   - не прерывать загрузку по Wi-Fi (не давай телефону уснуть);"
    'h.warn3' =  "   - если подсветка/тач/экран отключились — дважды нажми Power;"
    'h.warn4' =  "   - телефон почти невозможно окирпичить навсегда: iTunes всегда вернёт 1.x."
    'h.alpha' =  "АЛЬФА: программа в статусе альфа, могут быть ошибки. Всю ответственность за"
    'h.alpha2' =  "возможные поломки устройства несёшь ТЫ. Проект — только для учёбы и архива."
    'h.back' =  "  Enter — вернуться в меню"
    'm.putty.missing' =  "PuTTY не найден. Положи plink.exe и pscp.exe в папку:"
    'm.putty.link' =  "Скачать: https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe и pscp.exe"
}
de = @{
    'banner.title' =  "SKANKINSTALLER  ver. 1.0-Alpha"
    'banner.author' =  "Created By mUxa (u/Motor-Statement-8615)"
    'lang.saved' =  "Sprache gespeichert: {0}"
    'status.files.ready' =  "SkankPhone-Dateien : bereit"
    'status.files.no' =  "SkankPhone-Dateien : fehlen"
    'status.ssh.ready' =  "SSH-Werkzeuge      : bereit"
    'status.ssh.no' =  "SSH-Werkzeuge      : fehlen"
    'status.ip' =  "Telefon-IP         : {0}"
    'status.ip.none' =  "Telefon-IP         : nicht gesetzt"
    'menu.1' =  "1 - SkankPhone-Dateien prüfen/vorbereiten (Alpine 1A420)"
    'menu.2' =  "2 - Jailbreak-Werkzeuge prüfen + Anleitung (Antares/PXL)"
    'menu.3' =  "3 - Mit iPhone verbinden und prüfen (iOS-Version, Speicher)"
    'menu.4' =  "4 - SkankPhone AUF DEM TELEFON INSTALLIEREN"
    'menu.5' =  "5 - SkankPhone beim Start automatisch laden (Thread-Option)"
    'menu.6' =  "6 - SkankPhone entfernen (vollständiges Zurücksetzen)"
    'menu.7' =  "7 - Speicherplatz freigeben (/Applications bereinigen)"
    'menu.8' =  "8 - Hilfe und Links"
    'menu.0' =  "0 - Beenden"
    'prompt.choose' =  "  Option wählen"
    'prompt.enter' =  "  Eingabe - zurück zum Menü"
    'res.ok' =  "  [OK] Schritt abgeschlossen."
    'res.fail' =  "  [!] Schritt nicht abgeschlossen."
    's1.title' =  "SCHRITT 1. SkankPhone (Alpine 1A420) - Dateien prüfen und vorbereiten"
    's1.needtar' =  "tar.exe wird benötigt (Windows 10 1803+). Windows aktualisieren."
    's1.zip.missing' =  "Datei nicht gefunden: {0}"
    's1.zip.hint' =  "Lade sie selbst herunter und lege sie in diesen Ordner. Link in der Hilfe (Menü 8)."
    's1.zip.found' =  "Archiv gefunden: {0} ({1:N1} MB)"
    's1.md5' =  "Archiv-MD5: {0}"
    's1.md5.ok' =  "MD5 stimmt überein - das Archiv ist intakt."
    's1.md5.bad' =  "WARNUNG: MD5 stimmt nicht überein! Das Archiv könnte beschädigt sein."
    's1.md5.cont' =  "  Trotzdem fortfahren? (y/N)"
    's1.unpackzip' =  "Entpacke zip..."
    's1.unpackzip.err' =  "Fehler beim Entpacken des zip: {0}"
    's1.bz2.notfound' =  "prototype-fw.tar.bz2 im zip nicht gefunden!"
    's1.reading' =  "Lese den Inhalt von prototype-fw.tar.bz2..."
    's1.read.err' =  "Archiv konnte nicht gelesen werden: {0}"
    's1.entries.notfound' =  "Erwartete Pfade im Dump nicht gefunden (AppleInternal/SkankPhone.app/PrivateFrameworks)!"
    's1.ai' =  "AppleInternal (tar)      : {0}"
    's1.pf' =  "PrivateFrameworks (tar)  : {0}"
    's1.plist' =  "Autostart-Plist          : {0}"
    's1.plist.no' =  "Autostart-Plist          : nicht gefunden"
    's1.size.ai' =  "Größe AppleInternal      : {0:N1} MB"
    's1.size.pf' =  "Größe PrivateFrameworks  : {0:N1} MB"
    's1.done' =  "Fertig! Dateien sind für die Installation vorbereitet."
    's2.title' =  "SCHRITT 2. Jailbreak-Werkzeuge prüfen (Antares + PXLInstaller)"
    's2.expect' =  "Diese Dateien müssen MANUELL in den Ordner gelegt werden:"
    's2.missing' =  "FEHLEN (selbst herunterladen; Links in Hilfe/Menü 8 und README.txt):"
    's2.present' =  "Vorhanden:"
    's2.unpack' =  "Entpacke: {0}"
    's2.unpack.err' =  "Entpack-Fehler: {0}"
    's2.pxl' =  "PXL extrahiert: {0}"
    's2.opened' =  "Ordner im Explorer geöffnet: {0}"
    's2.done' =  "Alle Werkzeuge bereit. Unten folgt die Jailbreak-Anleitung."
    'jb.1' =  "JAILBREAK-ANLEITUNG (Antares, iPhone OS 1.0-1.1.5):"
    'jb.2' =  "1. iPhone per USB verbinden. Der Werkzeuge-Ordner hat sich geöffnet."
    'jb.3' =  "2. zadig.exe starten: Options -> List All Devices, das iPhone wählen (meist 'Apple Mobile Device (Interface 1)'). Treiber: libusbK -> Replace Driver. Bei Aufforderung neu starten."
    'jb.4' =  "3. antares-gui.exe starten -> Tools -> Enter Recovery."
    'jb.5' =  "4. In Zadig das Gerät im Recovery-Modus wählen (z.B. '... (IF0) (Interface 0)'), wieder libusbK -> Replace Driver. PC neu starten."
    'jb.6' =  "5. antares-gui.exe öffnen und Jailbreak drücken. Nach dem Neustart ist das Telefon gejailbreakt."
    'jb.7' =  "6. pxlinstaller-gui.exe starten: Install Application, und aus jailbreak\pxl-tweaks installieren:"
    'jb.8' =  "    - BSD Subsystem (*.pxl)  - tar/cp-Werkzeuge (UNVERZICHTBAR)"
    'jb.9' =  "    - Dropbear (*.pxl)       - SSH-Server (UNVERZICHTBAR)"
    'jb.10' =  "   Root-Passwort nach dem Jailbreak: alpine"
    'jb.11' =  "Nach Jailbreak und PXL-Installation - zurückkommen und SCHRITT 3 wählen."
    'c.title' =  "Verbindung zum iPhone 2G über SSH"
    'c.hint1' =  "IP des Telefons finden: Einstellungen -> WLAN -> blauer Pfeil beim Netzwerk -> IP-Adresse."
    'c.ip.prompt' =  "  Telefon-IP eingeben (z.B. 192.168.1.42; 'q' - Abbrechen)"
    'c.target' =  "Ziel: root@{0} (Passwort: {1})"
    'c.checking' =  "Prüfe Verbindung (erste Verbindung speichert den Host-Schlüssel)..."
    'c.nolink' =  "KEINE VERBINDUNG zum Telefon. Prüfen:"
    'c.chk1' =  "   - Telefon im selben WLAN wie der PC;"
    'c.chk2' =  "   - SSH installiert (Dropbear-PXL aus dem Jailbreak-Schritt);"
    'c.chk3' =  "   - IP korrekt (Bildschirm des Telefons schläft evtl. - aufwecken)."
    'c.resp' =  "Antwort: {0}"
    'c.linkok' =  "SSH-Verbindung OK."
    'c.ver' =  "iPhone-OS-Version: {0}"
    'c.stop1' =  "STOPP! SkankPhone darf NICHT auf echtem iPhone OS 1.0.x installiert werden - das"
    'c.stop2' =  "Telefon kann einen Brick erleiden (direkte Warnung des Thread-Autors). Auf 1.1.4/1.1.5 aktualisieren."
    'c.edited1' =  "WARNUNG: SystemVersion.plist zeigt 1.0, aber die Build-Nummer passt nicht zu echtem"
    'c.edited2' =  "1.0.x - die plist wurde wahrscheinlich manuell bearbeitet. Fahre fort."
    'c.other' =  "WARNUNG: Die Methode ist für iPhone OS 1.1.x getestet, du hast {0}."
    'c.risk' =  "  Auf eigenes Risiko fortfahren? (y/N)"
    'c.free' =  "Freier Speicher auf der Systempartition: {0:N1} MB"
    'c.note1' =  "Genaue Berechnung erfolgt bei der Installation (nur fehlende Frameworks werden kopiert)."
    'c.note2' =  "Reicht der Platz nicht, bietet der Installer selbst die Bereinigung an (Menü 7)."
    's4.title' =  "SCHRITT 4. SkankPhone auf dem iPhone installieren"
    's4.nostate' =  "Zuerst SCHRITT 1 ausführen (SkankPhone-Dateien nicht vorbereitet)."
    's4.bz2.gone' =  "prototype-fw.tar.bz2 nicht gefunden - SCHRITT 1 erneut ausführen."
    's4.bz2.found' =  "Archiv am neuen Pfad gefunden: {0}"
    's4.building' =  "Paket wird erstellt (AppleInternal + PrivateFrameworks)..."
    's4.builderr' =  "Fehler beim Erstellen des Pakets: {0}"
    's4.pkg' =  "Paket: {0:N1} MB"
    's4.probing' =  "Vergleiche Frameworks mit dem Telefon..."
    's4.stats' =  "Frameworks im Paket: {0}; bereits auf dem Telefon: {1}; hinzuzufügen: {2}"
    's4.adding' =  "Hinzugefügt wird: {0}"
    's4.need' =  "Benötigter Platz auf der Systempartition: ~{0} MB"
    's4.free' =  "Frei: {0:N1} MB"
    's4.little' =  "WENIG SPEICHER: {0:N1} MB frei, ~{1} MB benötigt."
    's4.little2' =  "Am einfachsten - Standard-Apps aus /Applications löschen (durch Neuflashen wiederherstellbar; so machte es der Thread-Autor)."
    's4.cleanprompt' =  "  /Applications jetzt bereinigen? (Y/n)"
    's4.stillbad' =  "Immer noch zu wenig Platz. Menü 7 erneut ausführen und weitere Apps löschen,"
    's4.stillbad2' =  "oder das Telefon auf sauberes 1.1.4 neu flashen - das bringt am meisten."
    's4.declined' =  "Installation abgebrochen. Platz freigeben (Menü 7) und es erneut versuchen."
    's4.plan1' =  "Wird ausgeführt (laut Thread-Anleitung):"
    's4.plan2' =  "   - /AppleInternal auf das Telefon kopieren;"
    's4.plan3' =  "   - NUR fehlende Frameworks nach /System/Library/PrivateFrameworks kopieren;"
    's4.plan4' =  "   - Symlink /Applications/SkankPhone.app erstellen;"
    's4.plan5' =  "   - Rechte für die Binärdatei setzen (chmod +rwx);"
    's4.plan6' =  "   - SpringBoard neu starten."
    's4.go' =  "  Fortfahren? (y/N)"
    's4.uploading' =  "Paket wird auf das Telefon geladen (WLAN - Telefon nicht einschlafen lassen!)..."
    's4.fallback' =  "pscp fehlgeschlagen, Fallback (cat über SSH)..."
    's4.uploaderr' =  "Upload fehlgeschlagen: {0}"
    's4.uploaded' =  "Paket hochgeladen."
    's4.installing' =  "Installiere auf dem Telefon..."
    's4.scripterr' =  "Fehler auf dem Telefon. Siehe obige Ausgabe und Protokoll."
    's4.respring' =  "SpringBoard wird neu gestartet..."
    's4.done1' =  "FERTIG! Das SkankPhone-Symbol sollte auf dem Homescreen erscheinen."
    's4.done2' =  "Wenn Display/Hintergrundbeleuchtung/Touch ausgehen - Power-Knopf zweimal drücken."
    's4.done3' =  "SkankPhone beim Start gewünscht - Menüpunkt 5 wählen."
    's5.title' =  "SCHRITT 5. SkankPhone-Autostart (OPTION aus dem Thread)"
    's5.warn' =  "WARNUNG: Danach startet das Telefon direkt in SkankPhone."
    's5.warn2' =  "Rückgängig: Menüpunkt 6 entfernt auch diese Plist."
    's5.prompt' =  "  Autostart aktivieren? (y/N)"
    's5.noplist' =  "com.apple.SkankPhone.plist nicht in /AppleInternal gefunden - Autostart nicht gesetzt."
    's5.ok' =  "Fertig! Telefon neu starten - es startet in SkankPhone."
    's5.reboot' =  "  Jetzt neu starten? (y/N)"
    's5.err' =  "Ausführung auf dem Telefon fehlgeschlagen (siehe Ausgabe oben)."
    's6.title' =  "SCHRITT 6. SkankPhone entfernen (vollständiges Zurücksetzen)"
    's6.plan1' =  "Wird entfernt:"
    's6.plan2' =  "   - Symlink /Applications/SkankPhone.app;"
    's6.plan3' =  "   - /AppleInternal komplett;"
    's6.plan4' =  "   - vom Installer HINZUGEFÜGTE Frameworks (über .spk_pf_manifest);"
    's6.plan5' =  "   - /System/Library/LaunchDaemons/com.apple.SkankPhone.plist (falls vorhanden)."
    's6.prompt' =  "  Fortfahren? (y/N)"
    's6.done' =  "SkankPhone entfernt. SpringBoard wird neu gestartet..."
    's6.err' =  "Fehler beim Entfernen (siehe Ausgabe oben)."
    'f.title' =  "Speicherplatz freigeben: Apps aus /Applications löschen"
    'f.count' =  "Einträge in /Applications gefunden: {0}"
    'f.row.mb' =  "    {0,8:N1} MB  {1}"
    'f.row.unk' =  "    (Größe unbekannt)  {0}"
    'f.total' =  "    Gesamt: ~{0:N1} MB"
    'f.safe1' =  "Standard-Apps können sicher gelöscht werden - Neuflashen stellt sie wieder her."
    'f.safe2' =  "Dropbear und BSD Subsystem liegen in /usr und bleiben unberührt."
    'f.safe3' =  "Über Installer.app installierte Apps - separat angeben, wenn sie bleiben sollen."
    'f.prompt1' =  "  App-Namen mit Komma getrennt eingeben (wie in der Liste oben),"
    'f.prompt2' =  "  'all' - ALLES aus /Applications löschen, Eingabe - Abbrechen."
    'f.prompt3' =  "  Was löschen?"
    'f.cancel' =  "Abgebrochen."
    'f.skip' =  "  Überspringe (nicht in /Applications gefunden): {0}"
    'f.nothing' =  "Nichts zu löschen."
    'f.removed' =  "Entfernte Einträge: {0}"
    'f.freenow' =  "Freier Speicher auf der Systempartition jetzt: {0:N1} MB"
    'f.listerr' =  "App-Liste konnte nicht vom Telefon abgerufen werden. Siehe Protokoll."
    'h.title' =  "HILFE"
    'h.link1' =  "Original-Thread mit der Anleitung:"
    'h.link2' =  "SkankPhone-Dateien (so findet man sie):"
    'h.dump1' =  "Google-Suche: site:archive.org switchboard"
    'h.dump2' =  "Suche eine Datei mit dem Titel `"Apple iOS SwitchBoard Firmwares (Common)`"."
    'h.dump3' =  "Darin befindet sich ein Zip-Archiv namens `"Alpine 1A420 (iPhone 2G).zip`"."
    'h.dump4' =  "Lade es herunter und öffne die Datei prototype-fw.tar.bz2 —"
    'h.dump5' =  "sie enthält alle Dateien für diese Anleitung."
    'h.link3' =  "Antares-Jailbreak-Anleitung:"
    'h.link4' =  "Manuelle Downloads (Dateien in die angegebenen Ordner legen):"
    'h.order' =  "Vorgehen:"
    'h.order1' =  "   1. SCHRITT 1 - Alpine-1A420-zip nach workspace\downloads legen und prüfen (Menü 1);"
    'h.order2' =  "   2. SCHRITT 2 - Werkzeuge nach workspace\jailbreak legen, dann mit Antares jailbreaken"
    'h.order3' =  "        und BSD Subsystem + Dropbear über PXLInstaller installieren;"
    'h.order4' =  "   3. SCHRITT 3 - per SSH verbinden (root / alpine);"
    'h.order5' =  "   4. SCHRITT 4 - SkankPhone installieren;"
    'h.order6' =  "   5. (optional) SCHRITT 5 - SkankPhone-Autostart;"
    'h.order7' =  "   6. SCHRITT 6 - vollständiges Zurücksetzen. Menüpunkt 7 - Speicher freigeben."
    'h.warn' =  "WICHTIGE WARNUNGEN (aus dem Thread):"
    'h.warn1' =  "   - NICHT auf echtem iPhone OS 1.0.x installieren - Brick-Gefahr;"
    'h.warn2' =  "   - WLAN-Übertragung nicht unterbrechen (Telefon nicht einschlafen lassen);"
    'h.warn3' =  "   - wenn Beleuchtung/Touch/Display ausgehen - Power zweimal drücken;"
    'h.warn4' =  "   - ein dauerhafter Brick ist fast unmöglich: iTunes stellt immer 1.x wieder her."
    'h.alpha' =  "ALPHA-HINWEIS: Diese Software ist in der Alpha-Phase und kann Fehler enthalten. Für"
    'h.alpha2' =  "Schäden am Gerät trägst DU die volle Verantwortung. Nur zu Lern-/Archivzwecken."
    'h.back' =  "  Eingabe - zurück zum Menü"
    'm.putty.missing' =  "PuTTY nicht gefunden. plink.exe und pscp.exe in diesen Ordner legen:"
    'm.putty.link' =  "Download: https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe und pscp.exe"
}
es = @{
    'banner.title' =  "SKANKINSTALLER  ver. 1.0-Alpha"
    'banner.author' =  "Created By mUxa (u/Motor-Statement-8615)"
    'lang.saved' =  "Idioma guardado: {0}"
    'status.files.ready' =  "Archivos SkankPhone : listos"
    'status.files.no' =  "Archivos SkankPhone : faltan"
    'status.ssh.ready' =  "Herramientas SSH    : listas"
    'status.ssh.no' =  "Herramientas SSH    : faltan"
    'status.ip' =  "IP del teléfono     : {0}"
    'status.ip.none' =  "IP del teléfono     : sin definir"
    'menu.1' =  "1 - Verificar/preparar archivos de SkankPhone (Alpine 1A420)"
    'menu.2' =  "2 - Verificar herramientas de jailbreak + guía (Antares/PXL)"
    'menu.3' =  "3 - Conectar con el iPhone y comprobar (versión iOS, espacio)"
    'menu.4' =  "4 - INSTALAR SkankPhone en el teléfono"
    'menu.5' =  "5 - Autoarranque de SkankPhone al encender (opción del hilo)"
    'menu.6' =  "6 - Desinstalar SkankPhone (reversión completa)"
    'menu.7' =  "7 - Liberar espacio del teléfono (limpiar /Applications)"
    'menu.8' =  "8 - Ayuda y enlaces"
    'menu.0' =  "0 - Salir"
    'prompt.choose' =  "  Elige una opción"
    'prompt.enter' =  "  Enter - volver al menú"
    'res.ok' =  "  [OK] Paso completado."
    'res.fail' =  "  [!] Paso no completado."
    's1.title' =  "PASO 1. SkankPhone (Alpine 1A420) - verificar y preparar archivos"
    's1.needtar' =  "Se necesita tar.exe (Windows 10 1803+). Actualiza Windows."
    's1.zip.missing' =  "Archivo no encontrado: {0}"
    's1.zip.hint' =  "Descárgalo tú mismo y colócalo en esta carpeta. Enlace en la Ayuda (menú 8)."
    's1.zip.found' =  "Archivo encontrado: {0} ({1:N1} MB)"
    's1.md5' =  "MD5 del archivo: {0}"
    's1.md5.ok' =  "MD5 coincide - el archivo está intacto."
    's1.md5.bad' =  "ADVERTENCIA: ¡el MD5 no coincide! El archivo puede estar dañado."
    's1.md5.cont' =  "  ¿Continuar de todos modos? (y/N)"
    's1.unpackzip' =  "Descomprimiendo zip..."
    's1.unpackzip.err' =  "Error al descomprimir el zip: {0}"
    's1.bz2.notfound' =  "¡prototype-fw.tar.bz2 no se encontró en el zip!"
    's1.reading' =  "Leyendo el contenido de prototype-fw.tar.bz2..."
    's1.read.err' =  "No se pudo leer el archivo: {0}"
    's1.entries.notfound' =  "¡No se encontraron las rutas esperadas en el dump (AppleInternal/SkankPhone.app/PrivateFrameworks)!"
    's1.ai' =  "AppleInternal (tar)      : {0}"
    's1.pf' =  "PrivateFrameworks (tar)  : {0}"
    's1.plist' =  "Plist de autoarranque    : {0}"
    's1.plist.no' =  "Plist de autoarranque    : no encontrado"
    's1.size.ai' =  "Tamaño de AppleInternal      : {0:N1} MB"
    's1.size.pf' =  "Tamaño de PrivateFrameworks  : {0:N1} MB"
    's1.done' =  "¡Listo! Archivos preparados para la instalación."
    's2.title' =  "PASO 2. Verificar herramientas de jailbreak (Antares + PXLInstaller)"
    's2.expect' =  "Estos archivos deben colocarse MANUALMENTE en la carpeta:"
    's2.missing' =  "FALTAN (descárgalos tú mismo; enlaces en Ayuda/menú 8 y README.txt):"
    's2.present' =  "Presentes:"
    's2.unpack' =  "Descomprimiendo: {0}"
    's2.unpack.err' =  "Error al descomprimir: {0}"
    's2.pxl' =  "PXL extraído: {0}"
    's2.opened' =  "Carpeta abierta en el Explorador: {0}"
    's2.done' =  "Todas las herramientas listas. La guía de jailbreak sigue abajo."
    'jb.1' =  "GUÍA DE JAILBREAK (Antares, iPhone OS 1.0-1.1.5):"
    'jb.2' =  "1. Conecta el iPhone por USB. La carpeta de herramientas ya se abrió."
    'jb.3' =  "2. Ejecuta zadig.exe: Options -> List All Devices, elige el iPhone (normalmente 'Apple Mobile Device (Interface 1)'). Controlador: libusbK -> Replace Driver. Si lo pide, reinicia."
    'jb.4' =  "3. Ejecuta antares-gui.exe -> Tools -> Enter Recovery."
    'jb.5' =  "4. En Zadig elige el dispositivo en Recovery (p.ej. '... (IF0) (Interface 0)'), instala libusbK otra vez -> Replace Driver. Reinicia el PC."
    'jb.6' =  "5. Abre antares-gui.exe y pulsa Jailbreak. Tras reiniciar, el teléfono está liberado."
    'jb.7' =  "6. Ejecuta pxlinstaller-gui.exe: Install Application, e instala desde jailbreak\pxl-tweaks:"
    'jb.8' =  "    - BSD Subsystem (*.pxl)  - utilidades tar/cp (OBLIGATORIO)"
    'jb.9' =  "    - Dropbear (*.pxl)       - servidor SSH (OBLIGATORIO)"
    'jb.10' =  "   Contraseña root tras el jailbreak: alpine"
    'jb.11' =  "Tras el jailbreak y los PXL - vuelve y elige el PASO 3."
    'c.title' =  "Conexión al iPhone 2G por SSH"
    'c.hint1' =  "Busca la IP del teléfono: Ajustes -> Wi-Fi -> flecha azul junto a la red -> Dirección IP."
    'c.ip.prompt' =  "  Introduce la IP del teléfono (ej. 192.168.1.42; 'q' - cancelar)"
    'c.target' =  "Destino: root@{0} (contraseña: {1})"
    'c.checking' =  "Comprobando conexión (la primera conexión guarda la clave del host)..."
    'c.nolink' =  "SIN CONEXIÓN con el teléfono. Comprueba:"
    'c.chk1' =  "   - el teléfono está en la misma red Wi-Fi que el PC;"
    'c.chk2' =  "   - SSH instalado (Dropbear PXL del paso de jailbreak);"
    'c.chk3' =  "   - la IP es correcta (la pantalla puede estar dormida - despiértala)."
    'c.resp' =  "Respuesta: {0}"
    'c.linkok' =  "Conexión SSH correcta."
    'c.ver' =  "Versión de iPhone OS: {0}"
    'c.stop1' =  "¡ALTO! NO instales SkankPhone en iPhone OS 1.0.x genuino - el teléfono puede"
    'c.stop2' =  "quedar inservible (advertencia directa del autor del hilo). Actualiza a 1.1.4/1.1.5."
    'c.edited1' =  "ADVERTENCIA: SystemVersion.plist muestra 1.0, pero la compilación no coincide con un"
    'c.edited2' =  "1.0.x genuino - parece que el plist se editó a mano. Continuando."
    'c.other' =  "ADVERTENCIA: el método está probado en iPhone OS 1.1.x, tú tienes {0}."
    'c.risk' =  "  ¿Continuar bajo tu propio riesgo? (y/N)"
    'c.free' =  "Espacio libre en la partición del sistema: {0:N1} MB"
    'c.note1' =  "El cálculo exacto se hace al instalar (solo se copian los frameworks que faltan)."
    'c.note2' =  "Si falta espacio, el instalador ofrecerá limpiar /Applications (menú 7)."
    's4.title' =  "PASO 4. Instalando SkankPhone en el iPhone"
    's4.nostate' =  "Ejecuta primero el PASO 1 (archivos de SkankPhone no preparados)."
    's4.bz2.gone' =  "prototype-fw.tar.bz2 no encontrado - ejecuta el PASO 1 de nuevo."
    's4.bz2.found' =  "Archivo encontrado en la nueva ruta: {0}"
    's4.building' =  "Creando el paquete (AppleInternal + PrivateFrameworks)..."
    's4.builderr' =  "Error al crear el paquete: {0}"
    's4.pkg' =  "Paquete: {0:N1} MB"
    's4.probing' =  "Comparando frameworks con el teléfono..."
    's4.stats' =  "Frameworks en el paquete: {0}; ya en el teléfono: {1}; por añadir: {2}"
    's4.adding' =  "A añadir: {0}"
    's4.need' =  "Espacio necesario en la partición del sistema: ~{0} MB"
    's4.free' =  "Libre: {0:N1} MB"
    's4.little' =  "POCO ESPACIO: {0:N1} MB libres, se necesitan ~{1} MB."
    's4.little2' =  "Lo más fácil - borrar apps de serie de /Applications (se restauran al reflashear; así lo hizo el autor del hilo)."
    's4.cleanprompt' =  "  ¿Limpiar /Applications ahora? (Y/n)"
    's4.stillbad' =  "Aún no hay espacio suficiente. Ejecuta el menú 7 otra vez y borra más apps,"
    's4.stillbad2' =  "o reflashea el teléfono a 1.1.4 limpio - es lo que más libera."
    's4.declined' =  "Instalación cancelada. Libera espacio (menú 7) e inténtalo de nuevo."
    's4.plan1' =  "Se hará (según la guía del hilo):"
    's4.plan2' =  "   - copiar /AppleInternal al teléfono;"
    's4.plan3' =  "   - añadir SOLO los frameworks que faltan a /System/Library/PrivateFrameworks;"
    's4.plan4' =  "   - crear el enlace simbólico /Applications/SkankPhone.app;"
    's4.plan5' =  "   - dar permisos al binario (chmod +rwx);"
    's4.plan6' =  "   - reiniciar SpringBoard."
    's4.go' =  "  ¿Continuar? (y/N)"
    's4.uploading' =  "Subiendo el paquete al teléfono (Wi-Fi, ¡no dejes que se duerma!)..."
    's4.fallback' =  "pscp falló, probando el método alternativo (cat por SSH)..."
    's4.uploaderr' =  "Error al subir el paquete: {0}"
    's4.uploaded' =  "Paquete subido."
    's4.installing' =  "Instalando en el teléfono..."
    's4.scripterr' =  "Error en el teléfono. Mira la salida de arriba y el registro."
    's4.respring' =  "Reiniciando SpringBoard..."
    's4.done1' =  "¡HECHO! El icono de SkankPhone debería aparecer en la pantalla de inicio."
    's4.done2' =  "Si se apagan la pantalla/luz/táctil - pulsa el botón Power dos veces."
    's4.done3' =  "¿Quieres SkankPhone al arrancar? Elige la opción 5 del menú."
    's5.title' =  "PASO 5. Autoarranque de SkankPhone (OPCIÓN del hilo)"
    's5.warn' =  "ADVERTENCIA: después de esto el teléfono arrancará directamente en SkankPhone."
    's5.warn2' =  "Reversión: el menú 6 también elimina este plist."
    's5.prompt' =  "  ¿Activar autoarranque? (y/N)"
    's5.noplist' =  "com.apple.SkankPhone.plist no encontrado en /AppleInternal - autoarranque no configurado."
    's5.ok' =  "¡Listo! Reinicia el teléfono - arrancará en SkankPhone."
    's5.reboot' =  "  ¿Reiniciar ahora? (y/N)"
    's5.err' =  "No se pudo ejecutar en el teléfono (ver salida arriba)."
    's6.title' =  "PASO 6. Desinstalar SkankPhone (reversión completa)"
    's6.plan1' =  "Se eliminará:"
    's6.plan2' =  "   - el enlace simbólico /Applications/SkankPhone.app;"
    's6.plan3' =  "   - /AppleInternal por completo;"
    's6.plan4' =  "   - los frameworks AÑADIDOS por el instalador (vía .spk_pf_manifest);"
    's6.plan5' =  "   - /System/Library/LaunchDaemons/com.apple.SkankPhone.plist (si existe)."
    's6.prompt' =  "  ¿Continuar? (y/N)"
    's6.done' =  "SkankPhone eliminado. Reiniciando SpringBoard..."
    's6.err' =  "Error al eliminar (ver salida arriba)."
    'f.title' =  "Liberando espacio: borrar apps de /Applications"
    'f.count' =  "Entradas encontradas en /Applications: {0}"
    'f.row.mb' =  "    {0,8:N1} MB  {1}"
    'f.row.unk' =  "    (tamaño desconocido)  {0}"
    'f.total' =  "    Total: ~{0:N1} MB"
    'f.safe1' =  "Las apps de serie se pueden borrar sin peligro - se restauran al reflashear a 1.1.4."
    'f.safe2' =  "Dropbear y BSD Subsystem viven en /usr y NO se ven afectados."
    'f.safe3' =  "Apps instaladas vía Installer.app - indícalas aparte si quieres conservarlas."
    'f.prompt1' =  "  Introduce los nombres de las apps separados por comas (como en la lista de arriba),"
    'f.prompt2' =  "  'all' - borrar TODO de /Applications, Enter - cancelar."
    'f.prompt3' =  "  ¿Qué borrar?"
    'f.cancel' =  "Cancelado."
    'f.skip' =  "  Omitiendo (no está en /Applications): {0}"
    'f.nothing' =  "Nada que borrar."
    'f.removed' =  "Entradas eliminadas: {0}"
    'f.freenow' =  "Espacio libre ahora en la partición del sistema: {0:N1} MB"
    'f.listerr' =  "No se pudo obtener la lista de apps del teléfono. Mira el registro."
    'h.title' =  "AYUDA"
    'h.link1' =  "Hilo original con la instrucción:"
    'h.link2' =  "Archivos de SkankPhone (cómo encontrarlos):"
    'h.dump1' =  "Busca en Google: site:archive.org switchboard"
    'h.dump2' =  "Busca un archivo titulado `"Apple iOS SwitchBoard Firmwares (Common)`"."
    'h.dump3' =  "Dentro encontrarás un zip llamado `"Alpine 1A420 (iPhone 2G).zip`"."
    'h.dump4' =  "Descárgalo y abre el archivo prototype-fw.tar.bz2;"
    'h.dump5' =  "contiene todos los archivos necesarios para seguir esta guía."
    'h.link3' =  "Guía del jailbreak Antares:"
    'h.link4' =  "Descargas manuales (coloca los archivos en las carpetas indicadas):"
    'h.order' =  "Orden de acciones:"
    'h.order1' =  "   1. PASO 1 - coloca el zip Alpine 1A420 en workspace\downloads y verifica (menú 1);"
    'h.order2' =  "   2. PASO 2 - coloca las herramientas en workspace\jailbreak, haz el jailbreak (Antares)"
    'h.order3' =  "        e instala BSD Subsystem + Dropbear con PXLInstaller;"
    'h.order4' =  "   3. PASO 3 - conéctate por SSH (root / alpine);"
    'h.order5' =  "   4. PASO 4 - instala SkankPhone;"
    'h.order6' =  "   5. (opcional) PASO 5 - autoarranque de SkankPhone;"
    'h.order7' =  "   6. PASO 6 - reversión completa. Menú 7 - liberar espacio."
    'h.warn' =  "ADVERTENCIAS IMPORTANTES (del hilo):"
    'h.warn1' =  "   - NO instalar en iPhone OS 1.0.x genuino - riesgo de inutilizar el teléfono;"
    'h.warn2' =  "   - no interrumpas la subida por Wi-Fi (no dejes dormir el teléfono);"
    'h.warn3' =  "   - si se apagan la luz/táctil/pantalla - pulsa Power dos veces;"
    'h.warn4' =  "   - un brick permanente es casi imposible: iTunes siempre restaura 1.x."
    'h.alpha' =  "AVISO ALFA: este software está en fase alfa y puede contener errores. Eres TÚ quien"
    'h.alpha2' =  "asume TODA la responsabilidad por daños al dispositivo. Solo fines educativos/de archivo."
    'h.back' =  "  Enter - volver al menú"
    'm.putty.missing' =  "PuTTY no encontrado. Coloca plink.exe y pscp.exe en la carpeta:"
    'm.putty.link' =  "Descarga: https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe y pscp.exe"
}
fr = @{
    'banner.title' =  "SKANKINSTALLER  ver. 1.0-Alpha"
    'banner.author' =  "Created By mUxa (u/Motor-Statement-8615)"
    'lang.saved' =  "Langue enregistrée : {0}"
    'status.files.ready' =  "Fichiers SkankPhone : prêts"
    'status.files.no' =  "Fichiers SkankPhone : absents"
    'status.ssh.ready' =  "Outils SSH          : prêts"
    'status.ssh.no' =  "Outils SSH          : absents"
    'status.ip' =  "IP du téléphone     : {0}"
    'status.ip.none' =  "IP du téléphone     : non définie"
    'menu.1' =  "1 - Vérifier/préparer les fichiers SkankPhone (Alpine 1A420)"
    'menu.2' =  "2 - Vérifier les outils de jailbreak + guide (Antares/PXL)"
    'menu.3' =  "3 - Se connecter à l'iPhone et vérifier (version iOS, espace)"
    'menu.4' =  "4 - INSTALLER SkankPhone sur le téléphone"
    'menu.5' =  "5 - Démarrage auto de SkankPhone (option du fil)"
    'menu.6' =  "6 - Désinstaller SkankPhone (retour complet)"
    'menu.7' =  "7 - Libérer de l'espace sur le téléphone (nettoyer /Applications)"
    'menu.8' =  "8 - Aide et liens"
    'menu.0' =  "0 - Quitter"
    'prompt.choose' =  "  Choisis une option"
    'prompt.enter' =  "  Entrée - retour au menu"
    'res.ok' =  "  [OK] Étape terminée."
    'res.fail' =  "  [!] Étape non terminée."
    's1.title' =  "ÉTAPE 1. SkankPhone (Alpine 1A420) - vérifier et préparer les fichiers"
    's1.needtar' =  "tar.exe est requis (Windows 10 1803+). Mets à jour Windows."
    's1.zip.missing' =  "Fichier introuvable : {0}"
    's1.zip.hint' =  "Télécharge-le toi-même et place-le dans ce dossier. Lien dans l'Aide (menu 8)."
    's1.zip.found' =  "Archive trouvée : {0} ({1:N1} Mo)"
    's1.md5' =  "MD5 de l'archive : {0}"
    's1.md5.ok' =  "MD5 identique - l'archive est intacte."
    's1.md5.bad' =  "AVERTISSEMENT : MD5 différent ! L'archive est peut-être corrompue."
    's1.md5.cont' =  "  Continuer quand même ? (y/N)"
    's1.unpackzip' =  "Décompression du zip..."
    's1.unpackzip.err' =  "Erreur de décompression du zip : {0}"
    's1.bz2.notfound' =  "prototype-fw.tar.bz2 introuvable dans le zip !"
    's1.reading' =  "Lecture du contenu de prototype-fw.tar.bz2..."
    's1.read.err' =  "Impossible de lire l'archive : {0}"
    's1.entries.notfound' =  "Chemins attendus introuvables dans le dump (AppleInternal/SkankPhone.app/PrivateFrameworks) !"
    's1.ai' =  "AppleInternal (tar)      : {0}"
    's1.pf' =  "PrivateFrameworks (tar)  : {0}"
    's1.plist' =  "Plist de démarrage auto  : {0}"
    's1.plist.no' =  "Plist de démarrage auto  : introuvable"
    's1.size.ai' =  "Taille AppleInternal     : {0:N1} Mo"
    's1.size.pf' =  "Taille PrivateFrameworks : {0:N1} Mo"
    's1.done' =  "Terminé ! Fichiers prêts pour l'installation."
    's2.title' =  "ÉTAPE 2. Vérification des outils de jailbreak (Antares + PXLInstaller)"
    's2.expect' =  "Ces fichiers doivent être placés MANUELLEMENT dans le dossier :"
    's2.missing' =  "MANQUANTS (à télécharger toi-même ; liens dans Aide/menu 8 et README.txt) :"
    's2.present' =  "Présents :"
    's2.unpack' =  "Décompression : {0}"
    's2.unpack.err' =  "Erreur de décompression : {0}"
    's2.pxl' =  "PXL extrait : {0}"
    's2.opened' =  "Dossier ouvert dans l'Explorateur : {0}"
    's2.done' =  "Tous les outils sont prêts. Le guide de jailbreak suit ci-dessous."
    'jb.1' =  "GUIDE DE JAILBREAK (Antares, iPhone OS 1.0-1.1.5) :"
    'jb.2' =  "1. Connecte l'iPhone en USB. Le dossier des outils s'est ouvert."
    'jb.3' =  "2. Lance zadig.exe : Options -> List All Devices, choisis l'iPhone (souvent 'Apple Mobile Device (Interface 1)'). Pilote : libusbK -> Replace Driver. Redémarre si demandé."
    'jb.4' =  "3. Lance antares-gui.exe -> Tools -> Enter Recovery."
    'jb.5' =  "4. Dans Zadig, choisis l'appareil en Recovery (ex. '... (IF0) (Interface 0)'), remets libusbK -> Replace Driver. Redémarre le PC."
    'jb.6' =  "5. Ouvre antares-gui.exe et clique Jailbreak. Après le redémarrage, le téléphone est jailbreaké."
    'jb.7' =  "6. Lance pxlinstaller-gui.exe : Install Application, et installe depuis jailbreak\pxl-tweaks :"
    'jb.8' =  "    - BSD Subsystem (*.pxl)  - utilitaires tar/cp (OBLIGATOIRE)"
    'jb.9' =  "    - Dropbear (*.pxl)       - serveur SSH (OBLIGATOIRE)"
    'jb.10' =  "   Mot de passe root après jailbreak : alpine"
    'jb.11' =  "Après le jailbreak et les PXL - reviens et choisis l'ÉTAPE 3."
    'c.title' =  "Connexion à l'iPhone 2G en SSH"
    'c.hint1' =  "Trouve l'IP du téléphone : Réglages -> Wi-Fi -> flèche bleue à côté du réseau -> Adresse IP."
    'c.ip.prompt' =  "  Entre l'IP du téléphone (ex. 192.168.1.42 ; 'q' - annuler)"
    'c.target' =  "Cible : root@{0} (mot de passe : {1})"
    'c.checking' =  "Vérification de la connexion (la première connexion mémorise la clé de l'hôte)..."
    'c.nolink' =  "PAS DE CONNEXION au téléphone. Vérifie :"
    'c.chk1' =  "   - le téléphone est sur le même réseau Wi-Fi que le PC ;"
    'c.chk2' =  "   - SSH est installé (Dropbear PXL de l'étape de jailbreak) ;"
    'c.chk3' =  "   - l'IP est correcte (l'écran du téléphone dort peut-être - réveille-le)."
    'c.resp' =  "Réponse : {0}"
    'c.linkok' =  "Connexion SSH OK."
    'c.ver' =  "Version iPhone OS : {0}"
    'c.stop1' =  "STOP ! N'installe PAS SkankPhone sur un vrai iPhone OS 1.0.x - le téléphone peut"
    'c.stop2' =  "être bloqué définitivement (avertissement direct de l'auteur du fil). Passe en 1.1.4/1.1.5."
    'c.edited1' =  "AVERTISSEMENT : SystemVersion.plist indique 1.0, mais le build ne correspond pas à un"
    'c.edited2' =  "vrai 1.0.x - le plist a probablement été modifié à la main. On continue."
    'c.other' =  "AVERTISSEMENT : la méthode est testée sur iPhone OS 1.1.x, tu as {0}."
    'c.risk' =  "  Continuer à tes risques et périls ? (y/N)"
    'c.free' =  "Espace libre sur la partition système : {0:N1} Mo"
    'c.note1' =  "Le calcul exact se fait à l'installation (seuls les frameworks manquants sont copiés)."
    'c.note2' =  "Si l'espace manque, l'installateur proposera de nettoyer /Applications (menu 7)."
    's4.title' =  "ÉTAPE 4. Installation de SkankPhone sur l'iPhone"
    's4.nostate' =  "Fais d'abord l'ÉTAPE 1 (fichiers SkankPhone non préparés)."
    's4.bz2.gone' =  "prototype-fw.tar.bz2 introuvable - relance l'ÉTAPE 1."
    's4.bz2.found' =  "Archive trouvée au nouvel emplacement : {0}"
    's4.building' =  "Création du paquet (AppleInternal + PrivateFrameworks)..."
    's4.builderr' =  "Erreur de création du paquet : {0}"
    's4.pkg' =  "Paquet : {0:N1} Mo"
    's4.probing' =  "Comparaison des frameworks avec le téléphone..."
    's4.stats' =  "Frameworks dans le paquet : {0} ; déjà sur le téléphone : {1} ; à ajouter : {2}"
    's4.adding' =  "À ajouter : {0}"
    's4.need' =  "Espace nécessaire sur la partition système : ~{0} Mo"
    's4.free' =  "Libre : {0:N1} Mo"
    's4.little' =  "PEU D'ESPACE : {0:N1} Mo libres, ~{1} Mo nécessaires."
    's4.little2' =  "Le plus simple - supprimer les apps d'origine de /Applications (restaurées en reflashant ; c'est ce qu'a fait l'auteur du fil)."
    's4.cleanprompt' =  "  Nettoyer /Applications maintenant ? (Y/n)"
    's4.stillbad' =  "Espace toujours insuffisant. Relance le menu 7 et supprime plus d'apps,"
    's4.stillbad2' =  "ou reflash le téléphone sur un 1.1.4 propre - c'est ce qui libère le plus."
    's4.declined' =  "Installation annulée. Libère de l'espace (menu 7) et réessaie."
    's4.plan1' =  "Ce qui va être fait (selon le guide du fil) :"
    's4.plan2' =  "   - copier /AppleInternal sur le téléphone ;"
    's4.plan3' =  "   - ajouter UNIQUEMENT les frameworks manquants dans /System/Library/PrivateFrameworks ;"
    's4.plan4' =  "   - créer le lien symbolique /Applications/SkankPhone.app ;"
    's4.plan5' =  "   - mettre les droits sur le binaire (chmod +rwx) ;"
    's4.plan6' =  "   - redémarrer SpringBoard."
    's4.go' =  "  Continuer ? (y/N)"
    's4.uploading' =  "Envoi du paquet vers le téléphone (Wi-Fi, ne laisse pas le téléphone dormir !)..."
    's4.fallback' =  "pscp a échoué, essai de la méthode de secours (cat en SSH)..."
    's4.uploaderr' =  "Échec de l'envoi : {0}"
    's4.uploaded' =  "Paquet envoyé."
    's4.installing' =  "Installation sur le téléphone..."
    's4.scripterr' =  "Erreur côté téléphone. Voir la sortie ci-dessus et le journal."
    's4.respring' =  "Redémarrage de SpringBoard..."
    's4.done1' =  "TERMINÉ ! L'icône SkankPhone devrait apparaître sur l'écran d'accueil."
    's4.done2' =  "Si l'écran/rétroéclairage/tactile se coupent - appuie deux fois sur Power."
    's4.done3' =  "Pour SkankPhone au démarrage - choisis l'option 5 du menu."
    's5.title' =  "ÉTAPE 5. Démarrage auto de SkankPhone (OPTION du fil)"
    's5.warn' =  "AVERTISSEMENT : après cela, le téléphone démarre directement dans SkankPhone."
    's5.warn2' =  "Annulation : le menu 6 supprime aussi cette plist."
    's5.prompt' =  "  Activer le démarrage auto ? (y/N)"
    's5.noplist' =  "com.apple.SkankPhone.plist introuvable dans /AppleInternal - démarrage auto non configuré."
    's5.ok' =  "Terminé ! Redémarre le téléphone - il démarrera dans SkankPhone."
    's5.reboot' =  "  Redémarrer maintenant ? (y/N)"
    's5.err' =  "Exécution impossible sur le téléphone (voir sortie ci-dessus)."
    's6.title' =  "ÉTAPE 6. Désinstallation de SkankPhone (retour complet)"
    's6.plan1' =  "Sera supprimé :"
    's6.plan2' =  "   - le lien symbolique /Applications/SkankPhone.app ;"
    's6.plan3' =  "   - /AppleInternal entièrement ;"
    's6.plan4' =  "   - les frameworks AJOUTÉS par l'installateur (via .spk_pf_manifest) ;"
    's6.plan5' =  "   - /System/Library/LaunchDaemons/com.apple.SkankPhone.plist (si présent)."
    's6.prompt' =  "  Continuer ? (y/N)"
    's6.done' =  "SkankPhone supprimé. Redémarrage de SpringBoard..."
    's6.err' =  "Erreur lors de la suppression (voir sortie ci-dessus)."
    'f.title' =  "Libération d'espace : suppression d'apps dans /Applications"
    'f.count' =  "Entrées trouvées dans /Applications : {0}"
    'f.row.mb' =  "    {0,8:N1} Mo  {1}"
    'f.row.unk' =  "    (taille inconnue)  {0}"
    'f.total' =  "    Total : ~{0:N1} Mo"
    'f.safe1' =  "Les apps d'origine peuvent être supprimées sans risque - restaurées en reflashant en 1.1.4."
    'f.safe2' =  "Dropbear et BSD Subsystem vivent dans /usr et ne seront PAS touchés."
    'f.safe3' =  "Apps installées via Installer.app - indique-les à part si tu veux les garder."
    'f.prompt1' =  "  Entre les noms des apps séparés par des virgules (comme dans la liste ci-dessus),"
    'f.prompt2' =  "  'all' - supprimer TOUT /Applications, Entrée - annuler."
    'f.prompt3' =  "  Que supprimer ?"
    'f.cancel' =  "Annulé."
    'f.skip' =  "  Ignoré (introuvable dans /Applications) : {0}"
    'f.nothing' =  "Rien à supprimer."
    'f.removed' =  "Entrées supprimées : {0}"
    'f.freenow' =  "Espace libre maintenant sur la partition système : {0:N1} Mo"
    'f.listerr' =  "Impossible d'obtenir la liste des apps du téléphone. Voir le journal."
    'h.title' =  "AIDE"
    'h.link1' =  "Fil original avec les instructions :"
    'h.link2' =  "Fichiers SkankPhone (comment les trouver) :"
    'h.dump1' =  "Recherche Google : site:archive.org switchboard"
    'h.dump2' =  "Cherche un fichier intitulé « Apple iOS SwitchBoard Firmwares (Common) »."
    'h.dump3' =  "À l'intérieur se trouve une archive zip nommée « Alpine 1A420 (iPhone 2G).zip »."
    'h.dump4' =  "Télécharge-la et ouvre le fichier prototype-fw.tar.bz2 ;"
    'h.dump5' =  "il contient tous les fichiers nécessaires pour suivre ce guide."
    'h.link3' =  "Guide du jailbreak Antares :"
    'h.link4' =  "Téléchargements manuels (place les fichiers dans les dossiers indiqués) :"
    'h.order' =  "Ordre des actions :"
    'h.order1' =  "   1. ÉTAPE 1 - place le zip Alpine 1A420 dans workspace\downloads et vérifie (menu 1) ;"
    'h.order2' =  "   2. ÉTAPE 2 - place les outils dans workspace\jailbreak, fais le jailbreak (Antares)"
    'h.order3' =  "        et installe BSD Subsystem + Dropbear via PXLInstaller ;"
    'h.order4' =  "   3. ÉTAPE 3 - connecte-toi en SSH (root / alpine) ;"
    'h.order5' =  "   4. ÉTAPE 4 - installe SkankPhone ;"
    'h.order6' =  "   5. (option) ÉTAPE 5 - démarrage auto de SkankPhone ;"
    'h.order7' =  "   6. ÉTAPE 6 - retour complet. Menu 7 - libérer de l'espace."
    'h.warn' =  "AVERTISSEMENTS IMPORTANTS (du fil) :"
    'h.warn1' =  "   - NE PAS installer sur un vrai iPhone OS 1.0.x - risque de brick ;"
    'h.warn2' =  "   - n'interromps pas l'envoi Wi-Fi (ne laisse pas le téléphone dormir) ;"
    'h.warn3' =  "   - si rétroéclairage/tactile/écran se coupent - appuie deux fois sur Power ;"
    'h.warn4' =  "   - un brick permanent est quasi impossible : iTunes restaure toujours 1.x."
    'h.alpha' =  "NOTE ALPHA : ce logiciel est en phase alpha et peut contenir des bugs. C'est TOI qui"
    'h.alpha2' =  "assumes TOUTE responsabilité en cas de dommage à l'appareil. Usage éducatif/archivistique uniquement."
    'h.back' =  "  Entrée - retour au menu"
    'm.putty.missing' =  "PuTTY introuvable. Place plink.exe et pscp.exe dans le dossier :"
    'm.putty.link' =  "Téléchargement : https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe et pscp.exe"
}
}

function T {
    param([Parameter(Mandatory=$true)][string]$Key, [Parameter(ValueFromRemainingArguments=$true)][object[]]$FmtArgs)
    $s = $Script:L[$Key]
    if ([string]::IsNullOrEmpty($s)) { $s = "<$Key>" }
    if ($FmtArgs -and $FmtArgs.Count -gt 0) {
        try { $s = ($s -f $FmtArgs) } catch { }
    }
    return $s
}

function Show-LanguagePrompt {
    Write-Host ""
    Write-Host "  Select language / Wahlen Sie die Sprache / Выберите язык / Elige el idioma / Choisissez la langue :" -ForegroundColor Cyan
    Write-Host "   1 - English (default)"
    Write-Host "   2 - Русский"
    Write-Host "   3 - Deutsch"
    Write-Host "   4 - Espanol"
    Write-Host "   5 - Francais"
    $ans = Read-Host "  >"
    switch ($ans.Trim()) {
        "2" { $Script:CurLang = "ru" }
        "3" { $Script:CurLang = "de" }
        "4" { $Script:CurLang = "es" }
        "5" { $Script:CurLang = "fr" }
        default { $Script:CurLang = "en" }
    }
    try {
        @{ lang = $Script:CurLang } | ConvertTo-Json | Set-Content -Path $Script:CfgFile -Encoding UTF8
    } catch { }
    $Script:L = $Script:LangTables[$Script:CurLang]
    Write-Log (T "lang.saved" $Script:CurLang) "DarkGray"
}

function Select-Language {
    # 1) CLI override, 2) saved config, 3) interactive menu (English default)
    $valid = @("en","ru","de","es","fr")
    if ($Lang -and ($valid -contains $Lang)) { $Script:CurLang = $Lang; return }

    if (Test-Path $Script:CfgFile) {
        try {
            $cfg = Get-Content $Script:CfgFile -Raw | ConvertFrom-Json
            if ($cfg.lang -and ($valid -contains $cfg.lang)) { $Script:CurLang = $cfg.lang; return }
        } catch { }
    }

    Show-LanguagePrompt
}

# ============================================================
#  Helpers
# ============================================================

function Write-Log {
    param([string]$Message, [string]$Color = "Gray")
    Write-Host $Message -ForegroundColor $Color
    if ($Script:LogFile) {
        Add-Content -Path $Script:LogFile -Value $Message -Encoding UTF8
    }
}

function Write-Title { param([string]$Text)
    Write-Host ""
    Write-Host ("=" * 62) -ForegroundColor Cyan
    Write-Host ("  " + $Text) -ForegroundColor Cyan
    Write-Host ("=" * 62) -ForegroundColor Cyan
}

function New-Log {
    $logDir = Join-Path $WorkDir "logs"
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    $Script:LogFile = Join-Path $logDir ("spk-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")
}

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Invoke-Native {
    param(
        [Parameter(Mandatory=$true)][string[]]$CmdArgs,
        [string]$StdIn
    )
    $old = $ErrorActionPreference
    $oldEnc = $OutputEncoding
    $ErrorActionPreference = "Continue"
    try {
        $OutputEncoding = New-Object System.Text.UTF8Encoding($false)
        $exe  = $CmdArgs[0]
        $rest = @($CmdArgs | Select-Object -Skip 1)
        if ($PSBoundParameters.ContainsKey("StdIn")) {
            $out = ($StdIn | & $exe @rest 2>&1)
        } else {
            $out = (& $exe @rest 2>&1)
        }
        return @{ Code = $LASTEXITCODE; Output = (@($out) -join "`n") }
    } finally {
        $ErrorActionPreference = $old
        $OutputEncoding = $oldEnc
    }
}

function Get-Md5 {
    param([string]$Path)
    (Get-FileHash -Path $Path -Algorithm MD5).Hash.ToLower()
}

# ============================================================
#  SSH to the phone
# ============================================================

function Check-Putty {
    # user provides plink.exe / pscp.exe manually (no downloads)
    if ((Test-Path $Script:PlinkPath) -and (Test-Path $Script:PscpPath)) { return $true }
    Write-Log (T "m.putty.missing") "Yellow"
    Write-Log ("    " + (Join-Path $WorkDir "tools")) "Yellow"
    Write-Log (T "m.putty.link") "Yellow"
    return $false
}

function Invoke-Phone {
    param([Parameter(Mandatory=$true)][string]$Command)
    if (-not (Test-Path $Script:PlinkPath)) {
        Write-Log (T "m.putty.missing") "Red"
        return $false
    }
    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), $Command)
    return ($r.Code -eq 0)
}

function Invoke-PhoneScript {
    param([Parameter(Mandatory=$true)][AllowEmptyString()][string]$Sh)
    $lf = $Sh -replace "`r`n", "`n"
    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "sh -s") -StdIn $lf
    return @{ Ok = ($r.Code -eq 0); Output = $r.Output }
}

function Connect-Phone {
    Write-Title (T "c.title")
    if (-not (Check-Putty)) { return $false }

    while ($true) {
        if ($Script:IP) { break }
        Write-Host ""
        Write-Host (T "c.hint1") -ForegroundColor White
        $entered = Read-Host (T "c.ip.prompt")
        if ($entered -match '^\s*(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*$') {
            $Script:IP = $Matches[1]
            break
        }
        if ($entered -match '^[qQйЙ]$') { return $false }
    }
    Write-Log (T "c.target" $Script:IP $Script:Password) "White"

    Write-Log (T "c.checking") "White"
    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "echo SPK_READY") -StdIn "y`n"
    if ($r.Output -notmatch "SPK_READY") {
        Write-Log (T "c.nolink") "Red"
        Write-Log (T "c.chk1") "Yellow"
        Write-Log (T "c.chk2") "Yellow"
        Write-Log (T "c.chk3") "Yellow"
        Write-Log (T "c.resp" $r.Output.Trim()) "DarkGray"
        $Script:IP = $null
        return $false
    }
    Write-Log (T "c.linkok") "Green"

    # iOS version - genuine 1.0.x is detected via ProductBuildVersion, not the
    # editable ProductVersion string
    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "cat /System/Library/CoreServices/SystemVersion.plist")
    $ver = $null; $build = $null
    if ($r.Output -match '(?s)ProductVersion.{0,120}?<string>\s*([0-9.]+)\s*</string>') { $ver = $Matches[1] }
    if ($r.Output -match '(?s)ProductBuildVersion.{0,120}?<string>\s*([0-9A-Za-z]+)\s*</string>') { $build = $Matches[1] }

    $verLine = (T "c.ver" $(if ($ver) { $ver } else { "?" }))
    if ($build) { $verLine += " ($build)" }
    Write-Log $verLine "White"

    if ($ver -and $ver.StartsWith("1.0")) {
        if ($build -match '^(1A5|1C)') {
            Write-Host ""
            Write-Host (T "c.stop1") -ForegroundColor Red
            Write-Host (T "c.stop2") -ForegroundColor Red
            return $false
        }
        Write-Host ""
        Write-Host (T "c.edited1") -ForegroundColor Yellow
        Write-Host (T "c.edited2") -ForegroundColor Yellow
    }
    elseif ($ver -and -not $ver.StartsWith("1.1")) {
        Write-Host ""
        Write-Host (T "c.other" $ver) -ForegroundColor Yellow
        $ans = Read-Host (T "c.risk")
        if ($ans -notmatch '^[YyДд]') { return $false }
    }

    # free space (exact math happens in STEP 4)
    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "df -k /")
    $freeKb = $null
    foreach ($line in ($r.Output -split "`n")) {
        if ($line -match '^/\S*\s+\d+\s+\d+\s+(\d+)') { $freeKb = [long]$Matches[1]; break }
    }
    if ($freeKb) {
        Write-Log (T "c.free" ($freeKb / 1024)) "White"
        Write-Log (T "c.note1") "DarkGray"
        Write-Log (T "c.note2") "DarkGray"
    }
    return $true
}

# ============================================================
#  STEP 1. Verify and prepare SkankPhone files (user-provided zip)
# ============================================================

function Step-DownloadPackage {
    Write-Title (T "s1.title")
    $dl  = Join-Path $WorkDir "downloads"
    $zip = Join-Path $dl $AlpineZipName

    if (-not (Test-CommandExists "tar.exe")) {
        Write-Log (T "s1.needtar") "Red"
        return $false
    }

    # user must provide the zip manually
    if (-not (Test-Path $zip)) {
        Write-Log (T "s1.zip.missing" $zip) "Red"
        Write-Log (T "s1.zip.hint") "Yellow"
        return $false
    }
    Write-Log (T "s1.zip.found" $zip ((Get-Item $zip).Length / 1MB)) "Green"

    # md5 check
    $hash = Get-Md5 $zip
    Write-Log (T "s1.md5" $hash) "DarkGray"
    if ($hash -ne $ZipMd5) {
        Write-Log (T "s1.md5.bad") "Yellow"
        $ans = Read-Host (T "s1.md5.cont")
        if ($ans -notmatch '^[YyДд]') { return $false }
    } else {
        Write-Log (T "s1.md5.ok") "Green"
    }

    # unpack zip (contains prototype-fw.tar.bz2)
    $zipDir = Join-Path $WorkDir "extracted\zip"
    $tbz = Get-ChildItem -Path $zipDir -Recurse -File -Filter "prototype-fw.tar.bz2" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $tbz) {
        Write-Log (T "s1.unpackzip") "White"
        New-Item -ItemType Directory -Force -Path $zipDir | Out-Null
        $r = Invoke-Native -CmdArgs @("tar.exe", "-xf", $zip, "-C", $zipDir)
        if ($r.Code -ne 0) {
            Write-Log (T "s1.unpackzip.err" $r.Output) "Red"
            return $false
        }
        $tbz = Get-ChildItem -Path $zipDir -Recurse -File -Filter "prototype-fw.tar.bz2" | Select-Object -First 1
    }
    if (-not $tbz) {
        Write-Log (T "s1.bz2.notfound") "Red"
        return $false
    }

    # read tar.bz2 contents WITHOUT unpacking to disk (symlinks must survive)
    Write-Log (T "s1.reading") "White"
    $r = Invoke-Native -CmdArgs @("tar.exe", "-tvf", $tbz.FullName)
    if ($r.Code -ne 0 -or -not $r.Output) {
        Write-Log (T "s1.read.err" $r.Output) "Red"
        return $false
    }
    $lines = $r.Output -split "`n"

    $entryRegex = '^(.)\S+\s+\S+\s+\S+\s+\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(.+)$'
    $aiRoot = $null; $pfRoot = $null
    $appOk = $false; $plistRel = $null
    $aiBytes = [long]0; $pfBytes = [long]0

    foreach ($line in $lines) {
        if (-not $line) { continue }
        $m = [regex]::Match($line, $entryRegex)
        if (-not $m.Success) { continue }
        $type = $m.Groups[1].Value
        $size = [long]$m.Groups[2].Value
        $path = $m.Groups[3].Value.Trim()

        if (-not $aiRoot -and $path -match '/AppleInternal/$') { $aiRoot = $path.TrimEnd('/') }
        if (-not $pfRoot -and $path -match '/System/Library/PrivateFrameworks/$') { $pfRoot = $path.TrimEnd('/') }
        if ($aiRoot -and $path -eq ($aiRoot + "/Applications/SkankPhone.app/SkankPhone")) { $appOk = $true }
        if ($aiRoot -and -not $plistRel -and $path -like ($aiRoot + "/*") -and $path -like "*com.apple.SkankPhone.plist") {
            $plistRel = $path.Substring($aiRoot.Length + 1)
        }
        if ($type -eq "-") {
            if ($aiRoot -and $path.StartsWith($aiRoot + "/")) { $aiBytes += $size }
            elseif ($pfRoot -and $path.StartsWith($pfRoot + "/")) { $pfBytes += $size }
        }
    }

    if (-not $aiRoot -or -not $appOk -or -not $pfRoot) {
        Write-Log (T "s1.entries.notfound") "Red"
        return $false
    }

    $state = [ordered]@{
        PayloadBz2             = $tbz.FullName
        AppleInternalRoot      = $aiRoot
        PrivateFrameworksRoot  = $pfRoot
        DaemonPlistRel         = $plistRel
        AppleInternalBytes     = $aiBytes
        PrivateFrameworksBytes = $pfBytes
        PreparedAt             = (Get-Date).ToString("s")
    }
    $state | ConvertTo-Json | Set-Content -Path $Script:StateFile -Encoding UTF8

    Write-Log ""
    Write-Log (T "s1.ai" $aiRoot) "Green"
    Write-Log (T "s1.pf" $pfRoot) "Green"
    if ($plistRel) { Write-Log (T "s1.plist" $plistRel) "Green" }
    else           { Write-Log (T "s1.plist.no") "Green" }
    Write-Log (T "s1.size.ai" ($aiBytes / 1MB)) "White"
    Write-Log (T "s1.size.pf" ($pfBytes / 1MB)) "White"
    Write-Log ""
    Write-Log (T "s1.done") "Green"
    return $true
}

# ============================================================
#  STEP 2. Check user-provided jailbreak tools
# ============================================================

function Step-JailbreakTools {
    Write-Title (T "s2.title")
    $jb = Join-Path $WorkDir "jailbreak"
    New-Item -ItemType Directory -Force -Path $jb | Out-Null

    Write-Host ""
    Write-Host (T "s2.expect") -ForegroundColor White
    Write-Host ("    " + $jb) -ForegroundColor White

    $missing = @()
    foreach ($f in $JbFiles) {
        if (-not (Test-Path (Join-Path $jb $f))) { $missing += $f }
    }
    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Host (T "s2.missing") -ForegroundColor Yellow
        foreach ($f in $missing) { Write-Host ("    - " + $f) -ForegroundColor Yellow }
    }

    # unpack zips that are present
    foreach ($z in @("Antares_Windows_x64.zip", "PXLInstaller_Windows_x64.zip")) {
        $src = Join-Path $jb $z
        if (Test-Path $src) {
            $dest = Join-Path $jb ([IO.Path]::GetFileNameWithoutExtension($z))
            if (-not (Test-Path (Join-Path $dest "SPK_UNPACKED"))) {
                Write-Log (T "s2.unpack" $z) "DarkGray"
                New-Item -ItemType Directory -Force -Path $dest | Out-Null
                try { Expand-Archive -Path $src -DestinationPath $dest -Force }
                catch { [void](Invoke-Native -CmdArgs @("tar.exe", "-xf", $src, "-C", $dest)) }
                New-Item -ItemType File -Force -Path (Join-Path $dest "SPK_UNPACKED") | Out-Null
            }
        }
    }

    # extract .pxl tweaks from PXLpak.zip (user-provided)
    $pxlDir = Join-Path $jb "pxl-tweaks"
    $pak    = Join-Path $jb "PXLpak.zip"
    if (Test-Path $pak) {
        New-Item -ItemType Directory -Force -Path $pxlDir | Out-Null
        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            $za = [IO.Compression.ZipFile]::OpenRead($pak)
            $za.Entries | Where-Object { $_.Name -like "*.pxl" } | ForEach-Object {
                $target = Join-Path $pxlDir $_.Name
                if (-not (Test-Path $target)) {
                    [IO.Compression.ZipFileExtensions]::ExtractToFile($_, $target, $false)
                    Write-Log (T "s2.pxl" $_.Name) "DarkGray"
                }
            }
            $za.Dispose()
        } catch { }
    }

    Write-Log (T "s2.opened" $jb) "White"
    Start-Process explorer.exe $jb

    if ($missing.Count -gt 0) { return $false }

    Write-Log (T "s2.done") "Green"
    Write-Host ""
    foreach ($k in @("jb.1","jb.2","jb.3","jb.4","jb.5","jb.6","jb.7","jb.8","jb.9","jb.10","jb.11")) {
        $color = "Yellow"
        if ($k -match '^jb\.(2|3|4|5|6|7|8|9|10)$') { $color = "White" }
        Write-Host (T $k) -ForegroundColor $color
    }
    return $true
}

# ============================================================
#  STEP 4. Install SkankPhone on the phone
# ============================================================

function Step-Install {
    Write-Title (T "s4.title")
    if (-not (Test-Path $Script:StateFile)) {
        Write-Log (T "s4.nostate") "Red"
        return $false
    }
    if (-not $Script:IP) {
        if (-not (Connect-Phone)) { return $false }
    }

    $st     = Get-Content $Script:StateFile -Raw | ConvertFrom-Json
    $bz2    = $st.PayloadBz2
    $aiRoot = $st.AppleInternalRoot
    $pfRoot = $st.PrivateFrameworksRoot

    # if the state holds an old path (folder was moved) - re-search locally
    if (-not (Test-Path $bz2)) {
        $found = Get-ChildItem -Path $WorkDir -Recurse -File -Filter "prototype-fw.tar.bz2" -ErrorAction SilentlyContinue |
                 Sort-Object { $_.FullName.Length } | Select-Object -First 1
        if ($found) {
            Write-Log (T "s4.bz2.found" $found.FullName) "Yellow"
            $bz2 = $found.FullName
            $st.PayloadBz2 = $bz2
            $st | ConvertTo-Json | Set-Content -Path $Script:StateFile -Encoding UTF8
        } else {
            Write-Log (T "s4.bz2.gone") "Red"
            return $false
        }
    }
    if (-not $aiRoot) { $aiRoot = "prototype-fw/AppleInternal" }
    if (-not $pfRoot) { $pfRoot = "prototype-fw/System/Library/PrivateFrameworks" }

    # build the compact package straight from tar.bz2 (symlinks and permissions survive)
    $subset = Join-Path $WorkDir "spk-payload.tgz"
    Write-Log (T "s4.building") "White"
    if (Test-Path $subset) { Remove-Item $subset -Force }
    $r = Invoke-Native -CmdArgs @("tar.exe", "-czf", $subset, `
            ("--include=" + $aiRoot + "/*"), ("--include=" + $pfRoot + "/*"), ("@" + $bz2))
    if ($r.Code -ne 0 -or -not (Test-Path $subset) -or ((Get-Item $subset).Length -lt 100KB)) {
        Write-Log (T "s4.builderr" $r.Output) "Red"
        return $false
    }
    Write-Log (T "s4.pkg" ((Get-Item $subset).Length / 1MB)) "DarkGray"

    # EXACT space check: only MISSING frameworks get copied
    Write-Log (T "s4.probing") "White"
    $probe = @'
for f in __PF__/*; do
    echo "__PF_HAVE__:${f##*/}"
done
echo "__PF_PROBE_DONE__"
'@
    $probe = $probe.Replace("__PF__", $DevPF)
    $res = Invoke-PhoneScript -Sh $probe
    $have = @{}
    foreach ($line in ($res.Output -split "`n")) {
        if ($line -match '^__PF_HAVE__:(.+?)\s*$') { $have[$Matches[1]] = $true }
    }

    $r = Invoke-Native -CmdArgs @("tar.exe", "-tvzf", $subset)
    $pfTop = @{}
    foreach ($line in ($r.Output -split "`n")) {
        $m = [regex]::Match($line, '^(.)\S+\s+\S+\s+\S+\s+\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(.+)$')
        if (-not $m.Success) { continue }
        if ($m.Groups[1].Value -ne "-") { continue }
        $path = $m.Groups[3].Value.Trim()
        if (-not $path.StartsWith($pfRoot + "/")) { continue }
        $rel = $path.Substring($pfRoot.Length + 1)
        if ($rel -notmatch '^([^/]+)/') { continue }
        $name = $Matches[1]
        if (-not $pfTop.ContainsKey($name)) { $pfTop[$name] = [long]0 }
        $pfTop[$name] += [long]$m.Groups[2].Value
    }

    $missing = @($pfTop.Keys | Where-Object { -not $have.ContainsKey($_) })
    $missingBytes = [long]0
    foreach ($n in $missing) { $missingBytes += $pfTop[$n] }
    $aiBytes = [long]0
    if ($st.AppleInternalBytes) { $aiBytes = [long]$st.AppleInternalBytes }
    $needMb = [math]::Ceiling((($aiBytes + $missingBytes) / 1MB) + 5)

    Write-Log (T "s4.stats" $pfTop.Count ($pfTop.Count - $missing.Count) $missing.Count) "White"
    if ($missing.Count -gt 0) {
        $mList = ($missing | ForEach-Object { "{0} ({1:N1})" -f $_, ($pfTop[$_] / 1MB) }) -join ", "
        Write-Log (T "s4.adding" $mList) "DarkGray"
    }
    Write-Log (T "s4.need" $needMb) "White"

    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "df -k /")
    $freeKb = $null
    foreach ($line in ($r.Output -split "`n")) {
        if ($line -match '^/\S*\s+\d+\s+\d+\s+(\d+)') { $freeKb = [long]$Matches[1]; break }
    }
    if ($freeKb) {
        Write-Log (T "s4.free" ($freeKb / 1024)) "White"
        if (($freeKb / 1024) -lt $needMb) {
            Write-Host ""
            Write-Host (T "s4.little" ($freeKb / 1024) $needMb) -ForegroundColor Yellow
            Write-Host (T "s4.little2") -ForegroundColor Yellow
            $ans = Read-Host (T "s4.cleanprompt")
            if ($ans -notmatch '^[NnНн]') {
                [void](Invoke-FreeSpace)
                $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "df -k /")
                $freeKb = $null
                foreach ($line in ($r.Output -split "`n")) {
                    if ($line -match '^/\S*\s+\d+\s+\d+\s+(\d+)') { $freeKb = [long]$Matches[1]; break }
                }
                if ($freeKb -and (($freeKb / 1024) -lt $needMb)) {
                    Write-Log (T "s4.stillbad") "Red"
                    Write-Log (T "s4.stillbad2") "Red"
                    return $false
                }
            } else {
                Write-Log (T "s4.declined") "Yellow"
                return $false
            }
        }
    }

    # confirmation
    Write-Host ""
    Write-Host (T "s4.plan1") -ForegroundColor Yellow
    foreach ($k in @("s4.plan2","s4.plan3","s4.plan4","s4.plan5","s4.plan6")) {
        Write-Host (T $k) -ForegroundColor White
    }
    Write-Host ""
    $ans = Read-Host (T "s4.go")
    if ($ans -notmatch '^[YyДд]') { return $false }

    # upload
    Write-Log (T "s4.uploading") "White"
    $r = Invoke-Native -CmdArgs @($Script:PscpPath, "-batch", "-scp", "-pw", $Script:Password, $subset, ("root@" + $Script:IP + ":" + $DevMedia))
    if ($r.Code -ne 0) {
        Write-Log (T "s4.fallback") "Yellow"
        $cmdLine = '"' + $Script:PlinkPath + '" -batch -ssh -pw ' + $Script:Password + ' root@' + $Script:IP + ' "cat > ' + $DevMedia + '" < "' + $subset + '"'
        $r2 = Invoke-Native -CmdArgs @("cmd.exe", "/c", $cmdLine)
        if ($r2.Code -ne 0) {
            Write-Log (T "s4.uploaderr" $r2.Output) "Red"
            return $false
        }
    }
    Write-Log (T "s4.uploaded") "Green"

    # install script on the phone (tokens replaced with real paths)
    $sh = @'
set -e
echo "SPK: unpacking..."
rm -rf __TMP__
mkdir -p __TMP__
tar -xzf __MEDIA__ -C __TMP__
AI_SRC=`find __TMP__ -type d -name AppleInternal | head -n1`
PF_SRC=`find __TMP__ -type d -path "*System/Library/PrivateFrameworks" | head -n1`
if [ -z "$AI_SRC" ] || [ -z "$PF_SRC" ]; then
    echo "SPK_ERR: folders not found in package"
    exit 1
fi
echo "SPK: AppleInternal..."
if [ -e __AI__ ]; then
    echo "SPK_NOTE: /AppleInternal already existed - replacing"
    rm -rf __AI__
fi
cp -Rp "$AI_SRC" __AI__
chmod -R 755 __AI__
echo "SPK: PrivateFrameworks (only missing)..."
mkdir -p __PF__
touch __MANIFEST__
for f in "$PF_SRC"/*; do
    n=`basename "$f"`
    if [ ! -e "__PF__/$n" ]; then
        cp -Rp "$f" "__PF__/$n"
        echo "$n" >> __MANIFEST__
        echo "SPK_PF_ADD: $n"
    else
        echo "SPK_PF_SKIP: $n"
    fi
done
rm -rf __TMP__
rm -f __MEDIA__
echo "SPK: symlink and permissions..."
if [ -e __APPS__ ]; then
    echo "SPK_NOTE: /Applications/SkankPhone.app already existed - replacing"
    rm -rf __APPS__
fi
ln -s __AI__/Applications/SkankPhone.app __APPS__
chmod +rwx __AI__/Applications/SkankPhone.app/SkankPhone
echo "SPK_DONE"
'@
    $sh = $sh.Replace("__TMP__", $DevTmpExtract)
    $sh = $sh.Replace("__MEDIA__", $DevMedia)
    $sh = $sh.Replace("__AI__", $DevAI)
    $sh = $sh.Replace("__PF__", $DevPF)
    $sh = $sh.Replace("__APPS__", $DevApps)
    $sh = $sh.Replace("__MANIFEST__", $DevManifest)

    Write-Log (T "s4.installing") "White"
    $res = Invoke-PhoneScript -Sh $sh
    Write-Log $res.Output "DarkGray"
    if (-not $res.Ok -or $res.Output -notmatch "SPK_DONE") {
        Write-Log (T "s4.scripterr") "Red"
        return $false
    }

    Write-Log (T "s4.respring") "White"
    [void](Invoke-Phone -Command "killall SpringBoard")
    Write-Host ""
    Write-Host (T "s4.done1") -ForegroundColor Green
    Write-Host (T "s4.done2") -ForegroundColor Yellow
    Write-Host (T "s4.done3") -ForegroundColor Cyan
    return $true
}

# ============================================================
#  STEP 5. SkankPhone autoboot (optional, from the thread)
# ============================================================

function Step-AutoBoot {
    Write-Title (T "s5.title")
    if (-not $Script:IP) {
        if (-not (Connect-Phone)) { return $false }
    }
    Write-Host ""
    Write-Host (T "s5.warn") -ForegroundColor Yellow
    Write-Host (T "s5.warn2") -ForegroundColor Yellow
    Write-Host ""
    $ans = Read-Host (T "s5.prompt")
    if ($ans -notmatch '^[YyДд]') { return $false }

    $sh = @'
set -e
PLIST=`find /AppleInternal -name "com.apple.SkankPhone.plist" 2>/dev/null | head -n1`
if [ -z "$PLIST" ]; then
    echo "SPK_NOPLIST"
    exit 0
fi
cp "$PLIST" __DAEMON__
chmod 644 __DAEMON__
echo "SPK_AUTOBOOT_OK ($PLIST)"
'@
    $sh = $sh.Replace("__DAEMON__", $DevDaemon)

    $res = Invoke-PhoneScript -Sh $sh
    Write-Log $res.Output "DarkGray"
    if ($res.Output -match "SPK_NOPLIST") {
        Write-Log (T "s5.noplist") "Yellow"
        return $false
    }
    if ($res.Output -match "SPK_AUTOBOOT_OK") {
        Write-Log (T "s5.ok") "Green"
        $ans2 = Read-Host (T "s5.reboot")
        if ($ans2 -match '^[YyДд]') { [void](Invoke-Phone -Command "reboot") }
        return $true
    }
    Write-Log (T "s5.err") "Red"
    return $false
}

# ============================================================
#  STEP 6. Uninstall (full revert)
# ============================================================

function Step-Uninstall {
    Write-Title (T "s6.title")
    if (-not $Script:IP) {
        if (-not (Connect-Phone)) { return $false }
    }
    Write-Host ""
    Write-Host (T "s6.plan1") -ForegroundColor Yellow
    foreach ($k in @("s6.plan2","s6.plan3","s6.plan4","s6.plan5")) {
        Write-Host (T $k) -ForegroundColor White
    }
    Write-Host ""
    $ans = Read-Host (T "s6.prompt")
    if ($ans -notmatch '^[YyДд]') { return $false }

    $sh = @'
set -e
if [ -f __MANIFEST__ ]; then
    echo "SPK: removing added frameworks..."
    while read n; do
        rm -rf "__PF__/$n"
    done < __MANIFEST__
fi
if [ -L __APPS__ ]; then
    rm -f __APPS__
    echo "SPK: symlink removed"
fi
if [ -f __DAEMON__ ]; then
    rm -f __DAEMON__
    echo "SPK: autoboot removed"
fi
if [ -e __AI__ ]; then
    rm -rf __AI__
    echo "SPK: /AppleInternal removed"
fi
rm -rf __TMP__
rm -f __MEDIA__
echo "SPK_UNINSTALL_DONE"
'@
    $sh = $sh.Replace("__MANIFEST__", $DevManifest)
    $sh = $sh.Replace("__PF__", $DevPF)
    $sh = $sh.Replace("__APPS__", $DevApps)
    $sh = $sh.Replace("__DAEMON__", $DevDaemon)
    $sh = $sh.Replace("__AI__", $DevAI)
    $sh = $sh.Replace("__TMP__", $DevTmpExtract)
    $sh = $sh.Replace("__MEDIA__", $DevMedia)

    $res = Invoke-PhoneScript -Sh $sh
    Write-Log $res.Output "DarkGray"
    if ($res.Output -match "SPK_UNINSTALL_DONE") {
        Write-Log (T "s6.done") "Green"
        [void](Invoke-Phone -Command "killall SpringBoard")
        return $true
    }
    Write-Log (T "s6.err") "Red"
    return $false
}

# ============================================================
#  Free up space (remove apps from /Applications)
# ============================================================

function Invoke-FreeSpace {
    Write-Title (T "f.title")
    if (-not $Script:IP) {
        if (-not (Connect-Phone)) { return $false }
    }

    $sh = @'
echo "__APPS_BEGIN__"
du -sk /Applications/* 2>/dev/null
echo "__APPS_LS__"
ls -1 /Applications 2>/dev/null
echo "__APPS_END__"
'@
    $res = Invoke-PhoneScript -Sh $sh
    $apps = @{}
    $mode = ""
    foreach ($line in ($res.Output -split "`n")) {
        if ($line -match '^__APPS_BEGIN__') { $mode = "du"; continue }
        if ($line -match '^__APPS_LS__')    { $mode = "ls"; continue }
        if ($line -match '^__APPS_END__')   { $mode = "";   continue }
        if ($mode -eq "du" -and $line -match '^(\d+)\s+/Applications/(.+?)\s*$') {
            $apps[$Matches[2]] = [long]$Matches[1]
        }
        elseif ($mode -eq "ls" -and $line.Trim() -and -not $apps.ContainsKey($line.Trim())) {
            $apps[$line.Trim()] = [long]0
        }
    }

    if ($apps.Count -eq 0) {
        Write-Log (T "f.listerr") "Red"
        Write-Log $res.Output "DarkGray"
        return $false
    }

    Write-Log (T "f.count" $apps.Count) "White"
    $totalKb = [long]0
    foreach ($e in ($apps.GetEnumerator() | Sort-Object Value -Descending)) {
        if ($e.Value -gt 0) { Write-Log (T "f.row.mb" ($e.Value / 1024) $e.Key) "Gray" }
        else                { Write-Log (T "f.row.unk" $e.Key) "Gray" }
        $totalKb += $e.Value
    }
    if ($totalKb -gt 0) { Write-Log (T "f.total" ($totalKb / 1024)) "White" }

    Write-Host ""
    Write-Host (T "f.safe1") -ForegroundColor Yellow
    Write-Host (T "f.safe2") -ForegroundColor Yellow
    Write-Host (T "f.safe3") -ForegroundColor Yellow
    Write-Host ""
    Write-Host (T "f.prompt1") -ForegroundColor White
    Write-Host (T "f.prompt2") -ForegroundColor White
    $ans = Read-Host (T "f.prompt3")

    if (-not $ans.Trim()) { Write-Log (T "f.cancel") "Yellow"; return $false }

    $names = @()
    if ($ans.Trim() -match '^(all|все|всё)$') {
        $names = @($apps.Keys)
    } else {
        foreach ($p in ($ans -split ',')) {
            $n = $p.Trim()
            if (-not $n) { continue }
            if ($apps.ContainsKey($n))              { $names += $n }
            elseif ($apps.ContainsKey($n + ".app")) { $names += ($n + ".app") }
            else { Write-Log (T "f.skip" $n) "Yellow" }
        }
    }
    if ($names.Count -eq 0) { Write-Log (T "f.nothing") "Yellow"; return $false }

    $rmScript = ""
    foreach ($n in $names) { $rmScript += ("rm -rf '/Applications/" + $n + "'`n") }
    $rmScript += 'echo "__CLEAN_DONE__"'
    $res = Invoke-PhoneScript -Sh $rmScript
    if ($res.Output -notmatch "__CLEAN_DONE__") {
        Write-Log (T "s6.err") "Red"
        Write-Log $res.Output "DarkGray"
        return $false
    }
    Write-Log (T "f.removed" $names.Count) "Green"

    $r = Invoke-Native -CmdArgs @($Script:PlinkPath, "-batch", "-ssh", "-pw", $Script:Password, ("root@" + $Script:IP), "df -k /")
    $freeKb = $null
    foreach ($line in ($r.Output -split "`n")) {
        if ($line -match '^/\S*\s+\d+\s+\d+\s+(\d+)') { $freeKb = [long]$Matches[1]; break }
    }
    if ($freeKb) {
        Write-Log (T "f.freenow" ($freeKb / 1024)) "Green"
    }
    return $true
}

# ============================================================
#  Help
# ============================================================

function Show-Help {
    Write-Title (T "h.title")
    Write-Host (T "h.link1") -ForegroundColor White
    Write-Host ("   " + $LinkThread) -ForegroundColor Gray
    Write-Host (T "h.link2") -ForegroundColor White
    foreach ($k in @("h.dump1","h.dump2","h.dump3","h.dump4","h.dump5")) {
        Write-Host ("   " + (T $k)) -ForegroundColor Gray
    }
    Write-Host (T "h.link3") -ForegroundColor White
    Write-Host ("   https://ios.cfw.guide/installing-antares/") -ForegroundColor Gray
    Write-Host ""
    Write-Host (T "h.link4") -ForegroundColor White
    Write-Host ("   workspace\downloads\ : " + $AlpineZipName) -ForegroundColor Gray
    Write-Host ("   workspace\jailbreak\ : Antares_Windows_x64.zip") -ForegroundColor Gray
    Write-Host ("       " + $LinkAntares) -ForegroundColor DarkGray
    Write-Host ("   workspace\jailbreak\ : PXLInstaller_Windows_x64.zip") -ForegroundColor Gray
    Write-Host ("       " + $LinkPXL) -ForegroundColor DarkGray
    Write-Host ("   workspace\jailbreak\ : zadig.exe") -ForegroundColor Gray
    Write-Host ("       " + $LinkZadig) -ForegroundColor DarkGray
    Write-Host ("   workspace\jailbreak\ : PXLpak.zip (BSDSubsystem + Terminal + dropbear inside)") -ForegroundColor Gray
    Write-Host ("       " + $LinkPXLpak) -ForegroundColor DarkGray
    Write-Host ("   workspace\tools\     : plink.exe + pscp.exe (PuTTY)") -ForegroundColor Gray
    Write-Host ("       " + $LinkPutty) -ForegroundColor DarkGray
    Write-Host ""
    Write-Host (T "h.order") -ForegroundColor Yellow
    foreach ($k in @("h.order1","h.order2","h.order3","h.order4","h.order5","h.order6","h.order7")) {
        Write-Host (T $k)
    }
    Write-Host ""
    Write-Host (T "h.warn") -ForegroundColor Red
    foreach ($k in @("h.warn1","h.warn2","h.warn3","h.warn4")) {
        Write-Host (T $k) -ForegroundColor Red
    }
    Write-Host ""
    Write-Host (T "h.alpha") -ForegroundColor Yellow
    Write-Host (T "h.alpha2") -ForegroundColor Yellow
    Write-Host ""
    Read-Host (T "h.back")
}

# ============================================================
#  Main menu
# ============================================================

function Show-Menu {
    Write-Host ""
    Write-Host ("=" * 62) -ForegroundColor Cyan
    Write-Host ("  " + (T "banner.title")) -ForegroundColor Cyan
    Write-Host ("  " + (T "banner.author")) -ForegroundColor DarkCyan
    Write-Host ("=" * 62) -ForegroundColor Cyan

    $stOk = Test-Path $Script:StateFile
    $pwOk = (Test-Path $Script:PlinkPath) -and (Test-Path $Script:PscpPath)
    if ($stOk) { Write-Host (T "status.files.ready") -ForegroundColor Green }
    else       { Write-Host (T "status.files.no")   -ForegroundColor DarkGray }
    if ($pwOk) { Write-Host (T "status.ssh.ready") -ForegroundColor Green }
    else       { Write-Host (T "status.ssh.no")   -ForegroundColor DarkGray }
    if ($Script:IP) { Write-Host (T "status.ip" $Script:IP) -ForegroundColor Green }
    else            { Write-Host (T "status.ip.none") -ForegroundColor DarkGray }
    Write-Host ""
    foreach ($k in @("menu.1","menu.2","menu.3","menu.4","menu.5","menu.6","menu.7","menu.8")) {
        Write-Host (T $k)
    }
    Write-Host "9 - Language / Язык / Sprache / Idioma / Langue"
    Write-Host (T "menu.0")
    Write-Host ""
}

function Main {
    New-Log
    New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
    Select-Language
    $Script:L = $Script:LangTables[$Script:CurLang]

    $Script:IP       = $IP
    $Script:Password = $Password

    while ($true) {
        Show-Menu
        $choice = Read-Host (T "prompt.choose")
        $ok = $false
        switch ($choice) {
            "1" { $ok = Step-DownloadPackage }
            "2" { $ok = Step-JailbreakTools }
            "3" { $ok = Connect-Phone }
            "4" { $ok = Step-Install }
            "5" { $ok = Step-AutoBoot }
            "6" { $ok = Step-Uninstall }
            "7" { $ok = Invoke-FreeSpace }
            "8" { Show-Help }
            "9" { Show-LanguagePrompt }
            "0" { return }
            default { }
        }
        if (@("1","2","3","4","5","6","7") -contains $choice) {
            if ($ok) { Write-Host "`n" (T "res.ok")   -ForegroundColor Green }
            else     { Write-Host "`n" (T "res.fail") -ForegroundColor Red }
            Read-Host (T "prompt.enter")
        }
    }
}

Main
