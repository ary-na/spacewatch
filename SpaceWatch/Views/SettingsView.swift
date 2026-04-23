//
//  SettingsView.swift
//  SpaceWatch
//
//  Created by Ary on 25/03/2026.
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    
    @ObservedObject var spaceManager: SpaceManager
    
    @State private var editingID: UUID? = nil
    @State private var editedName: String = ""
    @State private var launchAtLogin: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: General
            
            SectionHeader(title: "General")
            
            SettingsCard {
                
                Toggle(isOn: $launchAtLogin) {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text("Open at login")
                        
                        Text("SpaceWatch will launch automatically when you log in")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onChange(of: launchAtLogin) { _, newValue in
                    setLaunchAtLogin(newValue)
                }
            }
            
            
            // MARK: Spaces
            
            SectionHeader(title: "Spaces")
            
            SettingsCard {
                
                VStack(spacing: 0) {
                    
                    ForEach(spaceManager.spaces) { slot in
                        
                        HStack {
                            
                            if editingID == slot.id {
                                
                                TextField("Space name", text: $editedName)
                                    .textFieldStyle(.roundedBorder)
                                
                                Button("Save") {
                                    
                                    guard !editedName.isEmpty else { return }
                                    
                                    spaceManager.renameSpace(slot, to: editedName)
                                    editingID = nil
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("Cancel") {
                                    editingID = nil
                                }
                                
                            } else {
                                
                                Text(slot.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button("Rename") {
                                    
                                    editingID = slot.id
                                    editedName = slot.name
                                }
                                
                                Button(role: .destructive) {
                                    
                                    spaceManager.deleteSpace(slot)
                                    
                                } label: {
                                    
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        
                        if slot.id != spaceManager.spaces.last?.id {
                            Divider()
                        }
                    }
                }
            }
            
            
            Text("Switch to a desktop to register it, then rename it here.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            
            // MARK: About
            
            SectionHeader(title: "About")
            
            SettingsCard {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text("SpaceWatch")
                            .font(.headline)
                        
                        Text("Version 1.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(24)
        .frame(width: 420)
        .onAppear {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }
    
    
    func setLaunchAtLogin(_ enable: Bool) {
        
        do {
            
            if enable {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            
        } catch {
            print("Failed to set launch at login: \(error)")
        }
    }
}





// MARK: Section Header

struct SectionHeader: View {
    
    let title: String
    
    var body: some View {
        
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}





// MARK: Settings Card

struct SettingsCard<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        content
            .frame(maxWidth: .infinity, alignment: .leading) // ensures equal card width
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.08))
            )
    }
}
