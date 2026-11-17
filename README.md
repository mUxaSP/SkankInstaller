# SkankInstaller — ver. 1.0-Alpha

**Created By mUxa (u/Motor-Statement-8615)**

> [!WARNING]
> **ALPHA SOFTWARE — EDUCATIONAL AND ARCHIVAL PURPOSES ONLY.**
> It may contain bugs. **YOU** are fully responsible for any damage to your device.
> Not affiliated with Apple. No Apple files are included — all files are provided by the user manually.

**Languages:** English (default) · Русский · Deutsch · Español · Français — switch inside the program: menu item **9** (or at first launch).

---

## [EN]

### What it does

Installs **SkankPhone** (recovered from the Alpine 1A420 prototype dump) on the **iPhone 2G**, based on the guide from [r/Apple_Internal](https://www.reddit.com/r/Apple_Internal/comments/m76sce/). After installation a **SkankPhone icon** appears on the home screen.

### Requirements

- PC: **Windows 10** (1803+) or **Windows 11** + 30-pin USB cable
- **iPhone 2G** with firmware **1.1.4 or 1.1.5**
  > [!CAUTION]
  > NEVER install on a genuine iPhone OS 1.0.x — brick risk. The program checks this itself and will stop you.
- PC and phone in the **same Wi-Fi network**

### Files (put them in place yourself — the program downloads nothing)

| File | Folder |
|---|---|
| `1.0 Alpine 1A420 (iPhone 2G).zip` | `workspace\downloads\` |
| `Antares_Windows_x64.zip` | `workspace\jailbreak\` |
| `PXLInstaller_Windows_x64.zip` | `workspace\jailbreak\` |
| `zadig.exe` | `workspace\jailbreak\` |
| `PXLpak.zip` (contains `BSDSubsystem-1.5.pxl`, `Terminal.pxl`, `dropbear-0.49.pxl`) | `workspace\jailbreak\` |
| `plink.exe` + `pscp.exe` (PuTTY) | `workspace\tools\` |

> 💡 **Where to find the SkankPhone files:** search Google for `site:archive.org switchboard`. Look for a file titled **"Apple iOS SwitchBoard Firmwares (Common)."** Inside, you will find a zip archive named **"Alpine 1A420 (iPhone 2G).zip."** Download it and open the `prototype-fw.tar.bz2` file; it contains all the files required to follow this guide.

**Tool downloads:**
- PuTTY (`plink.exe` + `pscp.exe`): <https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe>
- Antares: <https://github.com/theiphoneos1project/Antares/releases>
- PXLInstaller: <https://github.com/theiphoneos1project/PXLInstaller/releases>
- Zadig: <https://github.com/pbatard/libwdi/releases>
- PXLpak: <http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip>

> ✅ The program checks every file itself — if something is missing or in the wrong folder, it tells you what and where.

### Installation

1. Put the files from the table into the folders shown.
2. Run `SkankInstaller.cmd`, pick your language.
3. **Menu 1** — verify and prepare the SkankPhone files.
4. **Menu 2** — the program checks the tools and shows the jailbreak guide on screen: Zadig (libusbK driver) → Antares → then install **BSD Subsystem** + **Dropbear** via PXLInstaller.
5. **Menu 3** — connect to the phone. It asks for the phone's IP: *Settings → Wi-Fi → blue arrow → "IP Address"*.
6. **Menu 4** — install SkankPhone. Don't touch the phone until it says DONE — then the icon appears.
7. **Menu 5** *(optional)* — boot straight into SkankPhone at power-on.
8. **Menu 6** — full uninstall / revert.
9. **Menu 7** — free up space (delete stock apps — they come back after reflashing). **Menu 8** — help. **Menu 9** — language.

### If something goes wrong

| Problem | Solution |
|---|---|
| Screen dark / touch not responding / backlight off | **Press Power twice.** Known quirk from the original guide. |
| No connection | Phone awake, same Wi-Fi, correct IP, Dropbear installed. |
| Not enough space | The program offers to clean `/Applications` itself. |
| Everything broken | iTunes → **Restore** — the phone returns to normal 1.1.4. |

---

## [RU]

### Что это делает

Устанавливает **SkankPhone** (извлечённый из дампа прототипа Alpine 1A420) на **iPhone 2G** по инструкции из [r/Apple_Internal](https://www.reddit.com/r/Apple_Internal/comments/m76sce/). После установки на экране появляется иконка **SkankPhone**.

### Что нужно

- ПК: **Windows 10** (1803+) или **Windows 11** + кабель 30-pin
- **iPhone 2G** с прошивкой **1.1.4 или 1.1.5**
  > [!CAUTION]
  > НИКОГДА не ставить на подлинную iPhone OS 1.0.x — риск окирпичить. Программа проверит это сама и остановит.
- ПК и телефон в **одной Wi-Fi сети**

### Файлы (кладёшь сам — программа ничего не качает)

| Файл | Папка |
|---|---|
| `1.0 Alpine 1A420 (iPhone 2G).zip` | `workspace\downloads\` |
| `Antares_Windows_x64.zip` | `workspace\jailbreak\` |
| `PXLInstaller_Windows_x64.zip` | `workspace\jailbreak\` |
| `zadig.exe` | `workspace\jailbreak\` |
| `PXLpak.zip` (внутри `BSDSubsystem-1.5.pxl`, `Terminal.pxl`, `dropbear-0.49.pxl`) | `workspace\jailbreak\` |
| `plink.exe` + `pscp.exe` (PuTTY) | `workspace\tools\` |

> 💡 **Где найти файлы SkankPhone:** ищи в Google `site:archive.org switchboard`. Найди файл **«Apple iOS SwitchBoard Firmwares (Common)»**. Внутри будет zip-архив **«Alpine 1A420 (iPhone 2G).zip»**. Скачай его и открой файл `prototype-fw.tar.bz2` — в нём всё, что нужно для этого гайда.

**Скачать инструменты:**
- PuTTY (`plink.exe` + `pscp.exe`): <https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe>
- Antares: <https://github.com/theiphoneos1project/Antares/releases>
- PXLInstaller: <https://github.com/theiphoneos1project/PXLInstaller/releases>
- Zadig: <https://github.com/pbatard/libwdi/releases>
- PXLpak: <http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip>

> ✅ Программа сама проверяет каждый файл — если что-то отсутствует или лежит не там, она скажет что и куда.

### Установка

1. Положи файлы из таблицы в указанные папки.
2. Запусти `SkankInstaller.cmd`, выбери язык.
3. **Пункт 1** — проверка и подготовка файлов SkankPhone.
4. **Пункт 2** — программа проверит инструменты и покажет инструкцию джейлбрейка: Zadig (драйвер libusbK) → Antares → затем через PXLInstaller поставь **BSD Subsystem** + **Dropbear**.
5. **Пункт 3** — подключение к телефону. Нужен IP телефона: *Настройки → Wi-Fi → синяя стрелка → «IP-адрес»*.
6. **Пункт 4** — установка. Не трогай телефон, пока не скажет «ГОТОВО» — появится иконка.
7. **Пункт 5** *(опция)* — включение телефона сразу в SkankPhone.
8. **Пункт 6** — полное удаление / откат.
9. **Пункт 7** — освободить место (удаление стоковых приложений — они вернутся при перепрошивке). **Пункт 8** — справка. **Пункт 9** — язык.

### Если что-то пошло не так

| Проблема | Решение |
|---|---|
| Экран тёмный / тач не работает / подсветка выключилась | **Дважды нажми Power.** Известная особенность из оригинального гайда. |
| Нет связи | Телефон разбужен, та же Wi-Fi сеть, верный IP, Dropbear установлен. |
| Мало места | Программа сама предложит очистить `/Applications`. |
| Всё сломалось | iTunes → **Восстановить** — телефон вернётся к обычной 1.1.4. |

---

## [DE]

### Was es macht

Installiert **SkankPhone** (aus dem Alpine-1A420-Prototyp-Dump) auf dem **iPhone 2G** — nach der Anleitung aus [r/Apple_Internal](https://www.reddit.com/r/Apple_Internal/comments/m76sce/). Danach erscheint das **SkankPhone-Symbol** auf dem Homescreen.

### Was du brauchst

- PC: **Windows 10** (1803+) oder **Windows 11** + 30-Pin-Kabel
- **iPhone 2G** mit Firmware **1.1.4 oder 1.1.5**
  > [!CAUTION]
  > NIEMALS auf echtem iPhone OS 1.0.x installieren — Brick-Gefahr. Das Programm prüft das selbst und stoppt.
- PC und Telefon im **selben WLAN**

### Dateien (MANUELL ablegen — das Programm lädt nichts selbst)

| Datei | Ordner |
|---|---|
| `1.0 Alpine 1A420 (iPhone 2G).zip` | `workspace\downloads\` |
| `Antares_Windows_x64.zip` | `workspace\jailbreak\` |
| `PXLInstaller_Windows_x64.zip` | `workspace\jailbreak\` |
| `zadig.exe` | `workspace\jailbreak\` |
| `PXLpak.zip` (enthält `BSDSubsystem-1.5.pxl`, `Terminal.pxl`, `dropbear-0.49.pxl`) | `workspace\jailbreak\` |
| `plink.exe` + `pscp.exe` (PuTTY) | `workspace\tools\` |

> 💡 **Wo findet man die SkankPhone-Dateien:** Google-Suche `site:archive.org switchboard`. Suche die Datei **„Apple iOS SwitchBoard Firmwares (Common)"**. Darin liegt das Zip-Archiv **„Alpine 1A420 (iPhone 2G).zip"**. Lade es herunter und öffne die Datei `prototype-fw.tar.bz2` — sie enthält alles für diese Anleitung.

**Werkzeuge herunterladen:**
- PuTTY (`plink.exe` + `pscp.exe`): <https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe>
- Antares: <https://github.com/theiphoneos1project/Antares/releases>
- PXLInstaller: <https://github.com/theiphoneos1project/PXLInstaller/releases>
- Zadig: <https://github.com/pbatard/libwdi/releases>
- PXLpak: <http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip>

> ✅ Das Programm prüft jede Datei selbst — fehlt etwas oder liegt am falschen Ort, sagt es dir, was und wohin.

### Installation

1. Dateien aus der Tabelle in die genannten Ordner legen.
2. `SkankInstaller.cmd` starten, Sprache wählen.
3. **Menü 1** — SkankPhone-Dateien prüfen und vorbereiten.
4. **Menü 2** — Programm prüft die Werkzeuge und zeigt die Jailbreak-Anleitung: Zadig (libusbK-Treiber) → Antares → dann **BSD Subsystem** + **Dropbear** über PXLInstaller installieren.
5. **Menü 3** — mit dem Telefon verbinden. IP des Telefons: *Einstellungen → WLAN → blauer Pfeil → „IP-Adresse"*.
6. **Menü 4** — installieren. Telefon nicht anfassen, bis „FERTIG" erscheint — dann kommt das Symbol.
7. **Menü 5** *(optional)* — Telefon startet direkt in SkankPhone.
8. **Menü 6** — vollständig entfernen / zurücksetzen.
9. **Menü 7** — Speicher freigeben (Standard-Apps löschen — kommen beim Neuflashen zurück). **Menü 8** — Hilfe. **Menü 9** — Sprache.

### Wenn etwas schiefgeht

| Problem | Lösung |
|---|---|
| Display dunkel / Touch reagiert nicht / Beleuchtung aus | **Power zweimal drücken.** Bekannte Besonderheit aus dem Original-Guide. |
| Keine Verbindung | Telefon wach, selbes WLAN, korrekte IP, Dropbear installiert. |
| Zu wenig Platz | Programm bietet selbst an, `/Applications` zu bereinigen. |
| Alles kaputt | iTunes → **Wiederherstellen** — Telefon ist wieder normal bei 1.1.4. |

---

## [ES]

### Qué hace

Instala **SkankPhone** (recuperado del dump del prototipo Alpine 1A420) en el **iPhone 2G** — según la guía de [r/Apple_Internal](https://www.reddit.com/r/Apple_Internal/comments/m76sce/). Después aparecerá el icono de **SkankPhone** en la pantalla de inicio.

### Qué necesitas

- PC: **Windows 10** (1803+) o **Windows 11** + cable de 30 pines
- **iPhone 2G** con firmware **1.1.4 o 1.1.5**
  > [!CAUTION]
  > NUNCA instalar en un iPhone OS 1.0.x genuino — riesgo de brick. El programa lo comprueba y se detiene.
- PC y teléfono en la **misma red Wi-Fi**

### Archivos (los colocas TÚ — el programa no descarga nada)

| Archivo | Carpeta |
|---|---|
| `1.0 Alpine 1A420 (iPhone 2G).zip` | `workspace\downloads\` |
| `Antares_Windows_x64.zip` | `workspace\jailbreak\` |
| `PXLInstaller_Windows_x64.zip` | `workspace\jailbreak\` |
| `zadig.exe` | `workspace\jailbreak\` |
| `PXLpak.zip` (contiene `BSDSubsystem-1.5.pxl`, `Terminal.pxl`, `dropbear-0.49.pxl`) | `workspace\jailbreak\` |
| `plink.exe` + `pscp.exe` (PuTTY) | `workspace\tools\` |

> 💡 **Dónde encontrar los archivos de SkankPhone:** busca en Google `site:archive.org switchboard`. Busca el archivo **"Apple iOS SwitchBoard Firmwares (Common)"**. Dentro está el zip **"Alpine 1A420 (iPhone 2G).zip"**. Descárgalo y abre el archivo `prototype-fw.tar.bz2`; contiene todo lo necesario para esta guía.

**Descargar herramientas:**
- PuTTY (`plink.exe` + `pscp.exe`): <https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe>
- Antares: <https://github.com/theiphoneos1project/Antares/releases>
- PXLInstaller: <https://github.com/theiphoneos1project/PXLInstaller/releases>
- Zadig: <https://github.com/pbatard/libwdi/releases>
- PXLpak: <http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip>

> ✅ El programa comprueba cada archivo — si falta algo o está en la carpeta equivocada, te dice qué y dónde.

### Instalación

1. Coloca los archivos de la tabla en las carpetas indicadas.
2. Ejecuta `SkankInstaller.cmd`, elige el idioma.
3. **Menú 1** — verificar y preparar los archivos de SkankPhone.
4. **Menú 2** — el programa comprueba las herramientas y muestra la guía de jailbreak: Zadig (driver libusbK) → Antares → luego instala **BSD Subsystem** + **Dropbear** con PXLInstaller.
5. **Menú 3** — conectar con el teléfono. Pide la IP: *Ajustes → Wi-Fi → flecha azul → «Dirección IP»*.
6. **Menú 4** — instalar. No toques el teléfono hasta que diga HECHO — entonces aparece el icono.
7. **Menú 5** *(opcional)* — arrancar directamente en SkankPhone al encender.
8. **Menú 6** — desinstalación / reversión completa.
9. **Menú 7** — liberar espacio (borrar apps de serie — vuelven al reflashear). **Menú 8** — ayuda. **Menú 9** — idioma.

### Si algo sale mal

| Problema | Solución |
|---|---|
| Pantalla oscura / táctil no responde / luz apagada | **Pulsa Power dos veces.** Peculiaridad conocida de la guía original. |
| Sin conexión | Teléfono despierto, misma Wi-Fi, IP correcta, Dropbear instalado. |
| Poco espacio | El programa ofrece limpiar `/Applications` por sí mismo. |
| Todo roto | iTunes → **Restaurar** — el teléfono vuelve a la 1.1.4 normal. |

---

## [FR]

### Ce que ça fait

Installe **SkankPhone** (récupéré du dump du prototype Alpine 1A420) sur l'**iPhone 2G** — d'après le guide de [r/Apple_Internal](https://www.reddit.com/r/Apple_Internal/comments/m76sce/). Ensuite, l'icône **SkankPhone** apparaît sur l'écran d'accueil.

### Ce qu'il faut

- PC : **Windows 10** (1803+) ou **Windows 11** + câble 30 broches
- **iPhone 2G** avec le firmware **1.1.4 ou 1.1.5**
  > [!CAUTION]
  > JAMAIS sur un vrai iPhone OS 1.0.x — risque de brick. Le programme le vérifie et s'arrête.
- PC et téléphone sur le **même réseau Wi-Fi**

### Fichiers (à placer TOI-MÊME — le programme ne télécharge rien)

| Fichier | Dossier |
|---|---|
| `1.0 Alpine 1A420 (iPhone 2G).zip` | `workspace\downloads\` |
| `Antares_Windows_x64.zip` | `workspace\jailbreak\` |
| `PXLInstaller_Windows_x64.zip` | `workspace\jailbreak\` |
| `zadig.exe` | `workspace\jailbreak\` |
| `PXLpak.zip` (contient `BSDSubsystem-1.5.pxl`, `Terminal.pxl`, `dropbear-0.49.pxl`) | `workspace\jailbreak\` |
| `plink.exe` + `pscp.exe` (PuTTY) | `workspace\tools\` |

> 💡 **Où trouver les fichiers SkankPhone :** recherche Google `site:archive.org switchboard`. Cherche le fichier **« Apple iOS SwitchBoard Firmwares (Common) »**. À l'intérieur se trouve le zip **« Alpine 1A420 (iPhone 2G).zip »**. Télécharge-le et ouvre le fichier `prototype-fw.tar.bz2` ; il contient tout le nécessaire pour ce guide.

**Télécharger les outils :**
- PuTTY (`plink.exe` + `pscp.exe`) : <https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe>
- Antares : <https://github.com/theiphoneos1project/Antares/releases>
- PXLInstaller : <https://github.com/theiphoneos1project/PXLInstaller/releases>
- Zadig : <https://github.com/pbatard/libwdi/releases>
- PXLpak : <http://web.archive.org/web/20210317193036/xnopyt.org/PXLpak.zip>

> ✅ Le programme vérifie chaque fichier — s'il en manque un ou s'il est au mauvais endroit, il te dit quoi et où.

### Installation

1. Place les fichiers du tableau dans les dossiers indiqués.
2. Lance `SkankInstaller.cmd`, choisis la langue.
3. **Menu 1** — vérifier et préparer les fichiers SkankPhone.
4. **Menu 2** — le programme vérifie les outils et affiche le guide de jailbreak : Zadig (pilote libusbK) → Antares → puis installe **BSD Subsystem** + **Dropbear** via PXLInstaller.
5. **Menu 3** — connexion au téléphone. Il demande l'IP : *Réglages → Wi-Fi → flèche bleue → « Adresse IP »*.
6. **Menu 4** — installer. Ne touche pas au téléphone jusqu'à « TERMINÉ » — ensuite l'icône apparaît.
7. **Menu 5** *(option)* — démarrer directement dans SkankPhone à l'allumage.
8. **Menu 6** — désinstallation / retour complet.
9. **Menu 7** — libérer de l'espace (supprimer les apps d'origine — elles reviennent au reflash). **Menu 8** — aide. **Menu 9** — langue.

### Si quelque chose ne va pas

| Problème | Solution |
|---|---|
| Écran noir / tactile ne répond plus / rétroéclairage coupé | **Appuie deux fois sur Power.** Particularité connue du guide original. |
| Pas de connexion | Téléphone réveillé, même Wi-Fi, IP correcte, Dropbear installé. |
| Pas assez d'espace | Le programme propose lui-même de nettoyer `/Applications`. |
| Tout est cassé | iTunes → **Restaurer** — le téléphone revient en 1.1.4 normal. |

---

<div align="center">

**SkankInstaller ver. 1.0-Alpha** · Created By **mUxa** (u/Motor-Statement-8615)
Educational / archival use only · Not affiliated with Apple Inc.

</div>
