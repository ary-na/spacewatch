````markdown name=README.md
# SpaceWatch

A lightweight **macOS menu bar app** that shows your **current Space (desktop) name** and lets you **rename** your Spaces for quick context switching.

Built with **SwiftUI** using `MenuBarExtra`, with a small settings window for managing Space labels.

---

## Features

- **Menu bar display** of the current Space name
- Automatically **detects Space changes**
- **Registers new Spaces** as you switch to them
- **Rename** Spaces from a simple settings UI
- **Delete** saved Space labels
- **Launch at login** toggle (via `ServiceManagement`)

---

## How it works

SpaceWatch listens for macOS Space changes (`NSWorkspace.activeSpaceDidChangeNotification`) and reads the active Space ID using private CGS APIs:

- `CGSMainConnectionID()`
- `CGSGetActiveSpace(...)`

It then maps Space IDs to user-friendly names and saves them locally using `UserDefaults`.

> Note: Because this uses CGS private APIs, behavior may vary across macOS versions.

---

## Requirements

- macOS (SwiftUI + menu bar app)
- Xcode (open the `.xcodeproj`)

---

## Getting started

1. Clone the repo:
   ```bash
   git clone https://github.com/ary-na/spacewatch.git
   cd spacewatch
   ```

2. Open in Xcode:
   - Open `SpaceWatch.xcodeproj`

3. Build & run:
   - Select the `SpaceWatch` scheme
   - Press **Run**

Once running, SpaceWatch will appear in your menu bar.

---

## Using SpaceWatch

### Registering Spaces
SpaceWatch only knows about a Space after you’ve visited it at least once.

- Switch to a desktop (Space) → SpaceWatch will register it.
- Open **Space Settings…** → rename it there.

### Renaming / Deleting
Open **Space Settings…** from the menu bar:

- Click **Rename** to set a custom name
- Click the **trash** icon to remove a saved label

### Launch at login
In **General**, enable **Open at login** to register the app with macOS login items.

---

## Project structure

- `SpaceWatch/SpaceWatchApp.swift` — app entry point (`MenuBarExtra` + settings window)
- `SpaceWatch/Managers/SpaceManger.swift` — Space detection + persistence
- `SpaceWatch/Views/MenuView.swift` — menu bar UI
- `SpaceWatch/Views/SettingsView.swift` — settings window (launch at login, rename/delete)

---

## Roadmap ideas

- Optional icon-only mode
- Export/import Space labels
- Better handling for reordered/removed Spaces
- Show Space numbers alongside names
- Per-display Space handling (if applicable)

---

## Contributing

Issues and PRs are welcome. If you’re proposing a change involving the Space detection layer, please describe your macOS version and what you observed.

---

## License

No license file is currently included. If you want this to be open-source, consider adding a `LICENSE` (MIT, Apache-2.0, GPL, etc.).
````
