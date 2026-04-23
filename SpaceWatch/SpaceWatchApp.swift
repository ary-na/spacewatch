//
//  SpaceWatchApp.swift
//  SpaceWatch
//
//  Created by Ary on 25/03/2026.
//

import SwiftUI

@main
struct SpaceWatchApp: App {
    @StateObject private var spaceManager = SpaceManager()
    
    var body: some Scene {
        MenuBarExtra(spaceManager.currentSpaceName) {
            MenuView(spaceManager: spaceManager)
        }
        
        Window("SpaceWatch", id: "settings") {
            SettingsView(spaceManager: spaceManager)
        }
        .windowResizability(.contentSize)
    }
}
