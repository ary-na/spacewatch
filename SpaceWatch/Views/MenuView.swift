//
//  MenuView.swift
//  SpaceWatch
//
//  Created by Ary on 25/03/2026.
//

import SwiftUI

struct MenuView: View {
    
    @ObservedObject var spaceManager: SpaceManager
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        
        // Spaces
        
        ForEach(spaceManager.spaces) { slot in
            
            Button {
                
                spaceManager.selectSpace(slot)
                
            } label: {
                
                HStack {
                    
                    Text(slot.name)
                    
                    Spacer()
                    
                    if slot.spaceID == spaceManager.currentSpaceID {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        
        Divider()
        
        
        // Settings
        
        Button {
            
            openWindow(id: "settings")
            NSApp.activate(ignoringOtherApps: true)
            
        } label: {
            
            HStack {
                
                Text("Space Settings...")
                
                Spacer()
            }
        }
        
        
        Divider()
        
        
        // Quit
        
        Button {
            
            NSApplication.shared.terminate(nil)
            
        } label: {
            
            HStack {
                
                Text("Quit")
                
                Spacer()
            }
        }
    }
}
