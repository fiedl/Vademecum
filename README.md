# Vademecum Wingolfiticum

Das Vademecum des [Wingolfs](https://wingolf.org) als iOS-App.

## Installation

Die Applikation befindet sich noch in der Entwicklung und ist **noch nicht** in den **App-Store** hochgeladen.

## Framework

Als Grundlage der iOS-App wird das [turbolinks-ios-Framework](https://github.com/turbolinks/turbolinks-ios) verwendet.

Serverseitig wird die [YourPlatform-Engine](https://github.com/fiedl/your_platform) auf Basis des [Ruby-on-Rails-Frameworks](https://github.com/rails/rails) verwendet.

## Entwicklung

### Was kommt wo hin?

Die iOS-App ist eine Hybrid-App nach der Vorlage von [Turbolinks](https://github.com/turbolinks/turbolinks). Nur wenige Views sind daher direkt im Swift-Code der App umgesetzt. Vielmehr werden die meisten Views serverseitig als HTML gerendert.

* Welcome: [your_platform/app/views/mobile/welcome](https://github.com/fiedl/your_platform/blob/master/app/views/mobile/welcome/index.html.haml)
* Dashboard: [your_platform/app/views/mobile/dashboard](https://github.com/fiedl/your_platform/blob/master/app/views/mobile/dashboard/index.html.haml)
* Error: [Vademecum/ErrorView.xib](https://github.com/fiedl/Vademecum/blob/master/Vademecum/ErrorView.xib), [Vademecm/Error.swift](https://github.com/fiedl/Vademecum/blob/master/Vademecum/Error.swift)

### Entwicklungsumgebung

* macOS
* Xcode muss installiert sein.
* Homebrew wird empfohlen. Installation: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* Git in einer aktuellen Version: `brew install git`
* Carthage als Framework-Manager. Installation: `brew install carthage`

### Projekt-Setup

```bash
# Projekt herunterladen
git clone git@github.com:fiedl/Vademecum.git
cd Vademecum

# Frameworks installieren
carthage update

# Projekt in Xcode öffnen
open "Vademecum Wingolfiticum.xcodeproj"
```

## Autor

(c) 2016, Sebastian Fiedlschuster.
