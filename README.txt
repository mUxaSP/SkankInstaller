================================================================
  SKANKINSTALLER  ver. 1.0-Alpha
  Created By mUxa (u/Motor-Statement-8615)
================================================================

 Installer for SkankPhone (Apple internal app, recovered from the
 Alpine 1A420 prototype dump) on the iPhone 2G (1st generation),
 based on the guide from r/Apple_Internal.

 Установщик SkankPhone (внутреннее приложение Apple, извлечённое
 из дампа прототипа Alpine 1A420) на iPhone 2G (1-го поколения)
 по инструкции из r/Apple_Internal.

 Languages / Языки / Sprachen / Idiomas / Langues :
   English (default), Русский, Deutsch, Espanol, Francais
 Select in the program: menu item 9 (or at first launch).
 Выбор в программе: пункт меню 9 (или при первом запуске).

 Program folder: Desktop\SkankInstaller (run SkankInstaller.cmd).

 ALPHA SOFTWARE - EDUCATIONAL AND ARCHIVAL USE ONLY.
 YOU are responsible for any damage to your device.
 АЛЬФА - ИСКЛЮЧИТЕЛЬНО ДЛЯ УЧЁБЫ И АРХИВА.
 Ответственность за устройство несёшь ТЫ.

----------------------------------------------------------------
[ENGLISH]
----------------------------------------------------------------

1. WHAT THIS PROGRAM DOES
   Installs SkankPhone (Apple internal application, recovered from
   the Alpine 1A420 prototype dump) on the iPhone 2G (1st gen),
   following the guide from r/Apple_Internal.
   The program does NOT download anything - all files must be
   provided by the user manually.

2. DISCLAIMER - READ FIRST
   - This software is in ALPHA. It may contain bugs.
   - YOU are fully responsible for any damage to your device.
   - This project is created EXCLUSIVELY for educational and
     archival purposes.

3. COMPONENTS REQUIRED
   PC:
     - Windows 10 1803 or newer (built-in tar.exe is required)
     - Free USB port + 30-pin cable
   Phone:
     - iPhone 2G (1st generation)
     - iPhone OS 1.1.4 or 1.1.5 (NEVER install on genuine 1.0.x!)
   Network:
     - PC and iPhone in the same Wi-Fi network
   Files you must download and place MANUALLY:
     workspace\downloads\ :
       - "1.0 Alpine 1A420 (iPhone 2G).zip"
         (MD5 79fbde0265e4ce508041319d0f4f3347)
     workspace\jailbreak\ :
       - Antares_Windows_x64.zip        (jailbreak tool)
       - PXLInstaller_Windows_x64.zip   (PXL package installer)
       - zadig.exe                      (USB driver helper)
       - PXLpak.zip                     (contains BSDSubsystem-1.5.pxl,
                                         Terminal.pxl, dropbear-0.49.pxl)
     workspace\tools\ :
       - plink.exe and pscp.exe (PuTTY, SSH automation)

4. QUICK START
   1) Put the files listed above into the folders shown.
   2) Run SkankInstaller.cmd (double click).
   3) Menu 1 - verify the Alpine 1A420 dump.
   4) Menu 2 - check the tools, jailbreak with the Antares guide,
      then install BSD Subsystem + Dropbear via PXLInstaller
      (root password: alpine).
   5) Menu 3 - SSH connect and checks.
   6) Menu 4 - install SkankPhone.
   7) Menu 5 (optional) - SkankPhone autoboot at power-on.
   8) Menu 6 - full uninstall/revert.
   9) Menu 7 - free up space on the system partition.

5. LINKS
   Original thread:  https://www.reddit.com/r/Apple_Internal/comments/m76sce/
   Alpine dump:      search Google for: site:archive.org switchboard
                     Look for a file titled "Apple iOS SwitchBoard
                     Firmwares (Common)." Inside, you will find a zip
                     archive named "Alpine 1A420 (iPhone 2G).zip."
                     Download it and open the "prototype-fw.tar.bz2"
                     file; it contains all the files required to
                     follow this guide.
   Antares:          https://github.com/theiphoneos1project/Antares/releases
   PXLInstaller:     https://github.com/theiphoneos1project/PXLInstaller/releases
   Zadig:            https://github.com/pbatard/libwdi/releases
   PXLpak:           http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip
   PuTTY:            https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe  (+ pscp.exe)

6. WARNINGS (from the original thread)
   - Do NOT install on genuine iPhone OS 1.0.x - brick risk.
   - Do not interrupt the Wi-Fi upload / do not let the phone sleep.
   - If the backlight/touch/screen turn off - press Power twice.
   - A permanent brick is nearly impossible: iTunes always restores 1.x.

----------------------------------------------------------------
[РУССКИЙ]
----------------------------------------------------------------

1. ЧТО ДЕЛАЕТ ПРОГРАММА
   Устанавливает SkankPhone (внутреннее приложение Apple,
   извлечённое из дампа прототипа Alpine 1A420) на iPhone 2G
   (1-го поколения) по инструкции из r/Apple_Internal.
   Программа НИЧЕГО не скачивает сама — все файлы пользователь
   кладёт вручную.

2. ДИСКЛЕЙМЕР — ПРОЧИТАЙ СНАЧАЛА
   - Программа в статусе АЛЬФА. Возможны ошибки.
   - Всю ответственность за поломку устройства несёшь ТЫ.
   - Проект создан ИСКЛЮЧИТЕЛЬНО в образовательных и архивных
     целях.

3. КОМПОНЕНТЫ, КОТОРЫЕ НУЖНЫ
   ПК:
     - Windows 10 1803 или новее (нужен встроенный tar.exe)
     - Свободный USB-порт + кабель 30-pin
   Телефон:
     - iPhone 2G (1-го поколения)
     - iPhone OS 1.1.4 или 1.1.5 (НИКОГДА не ставить на подлинную 1.0.x!)
   Сеть:
     - ПК и телефон в одной Wi-Fi сети
   Файлы, которые нужно скачать и положить ВРУЧНУЮ:
     workspace\downloads\ :
       - "1.0 Alpine 1A420 (iPhone 2G).zip"
         (MD5 79fbde0265e4ce508041319d0f4f3347)
     workspace\jailbreak\ :
       - Antares_Windows_x64.zip        (джейлбрейк)
       - PXLInstaller_Windows_x64.zip   (установщик PXL-пакетов)
       - zadig.exe                      (драйвер USB)
       - PXLpak.zip                     (внутри BSDSubsystem-1.5.pxl,
                                         Terminal.pxl, dropbear-0.49.pxl)
     workspace\tools\ :
       - plink.exe и pscp.exe (PuTTY, SSH-автоматизация)

4. БЫСТРЫЙ СТАРТ
   1) Положи файлы из списка выше в указанные папки.
   2) Запусти SkankInstaller.cmd (двойной клик).
   3) Пункт 1 — проверка дампа Alpine 1A420.
   4) Пункт 2 — проверка инструментов, джейлбрейк по гайду Antares,
      затем через PXLInstaller поставь BSD Subsystem + Dropbear
      (пароль root: alpine).
   5) Пункт 3 — подключение по SSH и проверки.
   6) Пункт 4 — установка SkankPhone.
   7) Пункт 5 (опция) — автозапуск SkankPhone при включении.
   8) Пункт 6 — полное удаление/откат.
   9) Пункт 7 — освободить место на системном разделе.

5. ССЫЛКИ
   Оригинальный тред: https://www.reddit.com/r/Apple_Internal/comments/m76sce/
   Дамп Alpine:      ищи в Google: site:archive.org switchboard
                     Найди файл "Apple iOS SwitchBoard Firmwares
                     (Common)". Внутри будет zip-архив "Alpine 1A420
                     (iPhone 2G).zip". Скачай его и открой файл
                     prototype-fw.tar.bz2 — в нём все файлы,
                     нужные для этого гайда.
   Antares:           https://github.com/theiphoneos1project/Antares/releases
   PXLInstaller:      https://github.com/theiphoneos1project/PXLInstaller/releases
   Zadig:             https://github.com/pbatard/libwdi/releases
   PXLpak:            http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip
   PuTTY:             https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe  (+ pscp.exe)

6. ПРЕДУПРЕЖДЕНИЯ (из оригинального треда)
   - НЕ ставить на подлинную iPhone OS 1.0.x — риск окирпичить.
   - Не прерывать загрузку по Wi-Fi / не давать телефону уснуть.
   - Если подсветка/тач/экран отключились — дважды нажми Power.
   - Окирпичить навсегда почти невозможно: iTunes всегда вернёт 1.x.

----------------------------------------------------------------
[DEUTSCH]
----------------------------------------------------------------

1. WAS DAS PROGRAMM MACHT
   Installiert SkankPhone (interne Apple-App, wiederhergestellt
   aus dem Alpine-1A420-Prototyp-Dump) auf dem iPhone 2G
   (1. Generation), nach der Anleitung aus r/Apple_Internal.
   Das Programm lädt NICHTS selbst herunter - alle Dateien muss
   der Benutzer manuell bereitstellen.

2. HINWEIS - ZUERST LESEN
   - Diese Software ist in der ALPHA-Phase und kann Fehler enthalten.
   - Für Schäden am Gerät trägst DU die volle Verantwortung.
   - Das Projekt wurde AUSSCHLIESSLICH zu Bildungs- und
     Archivzwecken erstellt.

3. BENÖTIGTE KOMPONENTEN
   PC:
     - Windows 10 1803 oder neuer (integriertes tar.exe erforderlich)
     - Freier USB-Anschluss + 30-Pin-Kabel
   Telefon:
     - iPhone 2G (1. Generation)
     - iPhone OS 1.1.4 oder 1.1.5 (NIEMALS auf echtem 1.0.x installieren!)
   Netzwerk:
     - PC und iPhone im selben WLAN
   Dateien, die du selbst herunterlädst und MANUELL ablegst:
     workspace\downloads\ :
       - "1.0 Alpine 1A420 (iPhone 2G).zip"
         (MD5 79fbde0265e4ce508041319d0f4f3347)
     workspace\jailbreak\ :
       - Antares_Windows_x64.zip        (Jailbreak-Tool)
       - PXLInstaller_Windows_x64.zip   (PXL-Paket-Installer)
       - zadig.exe                      (USB-Treiber-Helfer)
       - PXLpak.zip                     (enthält BSDSubsystem-1.5.pxl,
                                         Terminal.pxl, dropbear-0.49.pxl)
     workspace\tools\ :
       - plink.exe und pscp.exe (PuTTY, SSH-Automatisierung)

4. SCHNELLSTART
   1) Lege die Dateien von oben in die genannten Ordner.
   2) Starte SkankInstaller.cmd (Doppelklick).
   3) Menü 1 - Alpine-1A420-Dump prüfen.
   4) Menü 2 - Werkzeuge prüfen, Jailbreak nach der Antares-Anleitung,
      danach BSD Subsystem + Dropbear über PXLInstaller installieren
      (Root-Passwort: alpine).
   5) Menü 3 - SSH-Verbindung und Prüfungen.
   6) Menü 4 - SkankPhone installieren.
   7) Menü 5 (optional) - Autostart beim Einschalten.
   8) Menü 6 - vollständige Deinstallation/Rücksetzung.
   9) Menü 7 - Speicherplatz auf der Systempartition freigeben.

5. LINKS
   Original-Thread:  https://www.reddit.com/r/Apple_Internal/comments/m76sce/
   Alpine-Dump:      Google-Suche: site:archive.org switchboard
                     Suche eine Datei mit dem Titel "Apple iOS
                     SwitchBoard Firmwares (Common)". Darin
                     befindet sich ein Zip-Archiv namens "Alpine
                     1A420 (iPhone 2G).zip". Lade es herunter und
                     öffne die Datei prototype-fw.tar.bz2 - sie
                     enthält alle Dateien für diese Anleitung.
   Antares:          https://github.com/theiphoneos1project/Antares/releases
   PXLInstaller:     https://github.com/theiphoneos1project/PXLInstaller/releases
   Zadig:            https://github.com/pbatard/libwdi/releases
   PXLpak:           http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip
   PuTTY:            https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe  (+ pscp.exe)

6. WARNUNGEN (aus dem Original-Thread)
   - NICHT auf echtem iPhone OS 1.0.x installieren - Brick-Gefahr.
   - WLAN-Übertragung nicht unterbrechen / Telefon nicht schlafen lassen.
   - Wenn Hintergrundbeleuchtung/Touch/Display ausgehen - zweimal Power drücken.
   - Ein dauerhafter Brick ist fast unmöglich: iTunes stellt immer 1.x wieder her.

----------------------------------------------------------------
[ESPANOL]
----------------------------------------------------------------

1. QUÉ HACE ESTE PROGRAMA
   Instala SkankPhone (aplicación interna de Apple, recuperada del
   dump del prototipo Alpine 1A420) en el iPhone 2G (1ª generación),
   según la guía de r/Apple_Internal.
   El programa NO descarga nada - todos los archivos deben ser
   proporcionados por el usuario manualmente.

2. AVISO LEGAL - LEE PRIMERO
   - Este software está en FASE ALFA y puede contener errores.
   - Eres TÚ quien asume toda la responsabilidad por daños al dispositivo.
   - El proyecto se crea EXCLUSIVAMENTE con fines educativos y de archivo.

3. COMPONENTES NECESARIOS
   PC:
     - Windows 10 1803 o superior (se necesita el tar.exe integrado)
     - Puerto USB libre + cable de 30 pines
   Teléfono:
     - iPhone 2G (1ª generación)
     - iPhone OS 1.1.4 o 1.1.5 (¡NUNCA instalar en un 1.0.x genuino!)
   Red:
     - PC y teléfono en la misma red Wi-Fi
   Archivos que debes descargar y colocar MANUALMENTE:
     workspace\downloads\ :
       - "1.0 Alpine 1A420 (iPhone 2G).zip"
         (MD5 79fbde0265e4ce508041319d0f4f3347)
     workspace\jailbreak\ :
       - Antares_Windows_x64.zip        (herramienta de jailbreak)
       - PXLInstaller_Windows_x64.zip   (instalador de paquetes PXL)
       - zadig.exe                      (controlador USB)
       - PXLpak.zip                     (contiene BSDSubsystem-1.5.pxl,
                                         Terminal.pxl, dropbear-0.49.pxl)
     workspace\tools\ :
       - plink.exe y pscp.exe (PuTTY, automatización SSH)

4. INICIO RÁPIDO
   1) Coloca los archivos de arriba en las carpetas indicadas.
   2) Ejecuta SkankInstaller.cmd (doble clic).
   3) Menú 1 - verificar el dump Alpine 1A420.
   4) Menú 2 - comprobar herramientas, haz el jailbreak con la guía
      de Antares y luego instala BSD Subsystem + Dropbear con
      PXLInstaller (contraseña root: alpine).
   5) Menú 3 - conexión SSH y comprobaciones.
   6) Menú 4 - instalar SkankPhone.
   7) Menú 5 (opcional) - autoarranque de SkankPhone al encender.
   8) Menú 6 - desinstalación/reversión completa.
   9) Menú 7 - liberar espacio en la partición del sistema.

5. ENLACES
   Hilo original:    https://www.reddit.com/r/Apple_Internal/comments/m76sce/
   Dump Alpine:      busca en Google: site:archive.org switchboard
                     Busca un archivo titulado "Apple iOS
                     SwitchBoard Firmwares (Common)". Dentro
                     encontrarás un zip llamado "Alpine 1A420
                     (iPhone 2G).zip". Descárgalo y abre el archivo
                     prototype-fw.tar.bz2; contiene todos los
                     archivos necesarios para seguir esta guía.
   Antares:          https://github.com/theiphoneos1project/Antares/releases
   PXLInstaller:     https://github.com/theiphoneos1project/PXLInstaller/releases
   Zadig:            https://github.com/pbatard/libwdi/releases
   PXLpak:           http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip
   PuTTY:            https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe  (+ pscp.exe)

6. ADVERTENCIAS (del hilo original)
   - NO instalar en iPhone OS 1.0.x genuino - riesgo de brick.
   - No interrumpas la subida por Wi-Fi / no dejes dormir el teléfono.
   - Si se apagan la luz/táctil/pantalla - pulsa Power dos veces.
   - Un brick permanente es casi imposible: iTunes siempre restaura 1.x.

----------------------------------------------------------------
[FRANCAIS]
----------------------------------------------------------------

1. CE QUE FAIT CE PROGRAMME
   Installe SkankPhone (application interne d'Apple, récupérée du
   dump du prototype Alpine 1A420) sur l'iPhone 2G (1re génération),
   en suivant le guide de r/Apple_Internal.
   Le programme ne télécharge RIEN - tous les fichiers doivent
   être fournis manuellement par l'utilisateur.

2. AVERTISSEMENT - À LIRE D'ABORD
   - Ce logiciel est en PHASE ALPHA et peut contenir des bugs.
   - C'est TOI qui assumes toute la responsabilité des dommages
     causés à l'appareil.
   - Le projet est créé EXCLUSIVEMENT à des fins éducatives et
     d'archivage.

3. COMPOSANTS REQUIS
   PC :
     - Windows 10 1803 ou plus récent (tar.exe intégré requis)
     - Port USB libre + câble 30 broches
   Téléphone :
     - iPhone 2G (1re génération)
     - iPhone OS 1.1.4 ou 1.1.5 (JAMAIS sur un vrai 1.0.x !)
   Réseau :
     - PC et iPhone sur le même réseau Wi-Fi
   Fichiers à télécharger et placer MANUELLEMENT :
     workspace\downloads\ :
       - "1.0 Alpine 1A420 (iPhone 2G).zip"
         (MD5 79fbde0265e4ce508041319d0f4f3347)
     workspace\jailbreak\ :
       - Antares_Windows_x64.zip        (outil de jailbreak)
       - PXLInstaller_Windows_x64.zip   (installateur de paquets PXL)
       - zadig.exe                      (assistant de pilote USB)
       - PXLpak.zip                     (contient BSDSubsystem-1.5.pxl,
                                         Terminal.pxl, dropbear-0.49.pxl)
     workspace\tools\ :
       - plink.exe et pscp.exe (PuTTY, automatisation SSH)

4. DÉMARRAGE RAPIDE
   1) Place les fichiers ci-dessus dans les dossiers indiqués.
   2) Lance SkankInstaller.cmd (double clic).
   3) Menu 1 - vérifier le dump Alpine 1A420.
   4) Menu 2 - vérifier les outils, fais le jailbreak avec le guide
      Antares puis installe BSD Subsystem + Dropbear via
      PXLInstaller (mot de passe root : alpine).
   5) Menu 3 - connexion SSH et vérifications.
   6) Menu 4 - installer SkankPhone.
   7) Menu 5 (option) - démarrage auto de SkankPhone à l'allumage.
   8) Menu 6 - désinstallation/retour complet.
   9) Menu 7 - libérer l'espace de la partition système.

5. LIENS
   Fil original :    https://www.reddit.com/r/Apple_Internal/comments/m76sce/
   Dump Alpine :     recherche Google : site:archive.org switchboard
                     Cherche un fichier intitulé « Apple iOS
                     SwitchBoard Firmwares (Common) ». À l'intérieur
                     se trouve une archive zip nommée « Alpine 1A420
                     (iPhone 2G).zip ». Télécharge-la et ouvre le
                     fichier prototype-fw.tar.bz2 ; il contient tous
                     les fichiers nécessaires pour suivre ce guide.
   Antares :         https://github.com/theiphoneos1project/Antares/releases
   PXLInstaller :    https://github.com/theiphoneos1project/PXLInstaller/releases
   Zadig :           https://github.com/pbatard/libwdi/releases
   PXLpak :          http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip
   PuTTY :           https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe  (+ pscp.exe)

6. AVERTISSEMENTS (du fil original)
   - NE PAS installer sur un vrai iPhone OS 1.0.x - risque de brick.
   - N'interromps pas l'envoi Wi-Fi / ne laisse pas le téléphone dormir.
   - Si rétroéclairage/tactile/écran se coupent - appuie deux fois sur Power.
   - Un brick permanent est quasi impossible : iTunes restaure toujours 1.x.

================================================================
  SKANKINSTALLER ver. 1.0-Alpha - Created By mUxa
  (u/Motor-Statement-8615) - Educational / archival use only.
================================================================
