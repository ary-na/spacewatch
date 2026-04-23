//
//  SpaceManger.swift
//  SpaceWatch
//
//  Created by Ary on 25/03/2026.
//

import SwiftUI
import Combine

@_silgen_name("CGSMainConnectionID")
func CGSMainConnectionID() -> UInt32

@_silgen_name("CGSGetActiveSpace")
func CGSGetActiveSpace(_ conn: UInt32) -> Int

class SpaceManager: ObservableObject {
    @Published var currentSpaceName: String = "Space 1"
    @Published var currentSpaceID: Int = 0
    @Published var spaces: [SpaceSlot] = []
    
    init() {
        // Load saved spaces from disk
        loadSpaces()
        
        let spaceID = CGSGetActiveSpace(CGSMainConnectionID())
        currentSpaceID = spaceID
        addSpaceIfNeeded(id: spaceID)
        updateLabel()
        
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.spaceDidChange()
        }
    }
    
    func spaceDidChange() {
        let spaceID = CGSGetActiveSpace(CGSMainConnectionID())
        currentSpaceID = spaceID
        addSpaceIfNeeded(id: spaceID)
        updateLabel()
    }
    
    func addSpaceIfNeeded(id: Int) {
        if !spaces.contains(where: { $0.spaceID == id }) {
            let number = spaces.count + 1
            spaces.append(SpaceSlot(spaceID: id, name: "Space \(number)"))
            saveSpaces()
        }
    }
    
    func updateLabel() {
        if let slot = spaces.first(where: { $0.spaceID == currentSpaceID }) {
            currentSpaceName = slot.name
        }
    }
    
    func selectSpace(_ slot: SpaceSlot) {
        currentSpaceName = slot.name
    }
    
    func renameSpace(_ slot: SpaceSlot, to newName: String) {
        if let index = spaces.firstIndex(where: { $0.spaceID == slot.spaceID }) {
            spaces[index].name = newName
            if slot.spaceID == currentSpaceID {
                currentSpaceName = newName
            }
            saveSpaces()
        }
    }
    
    func deleteSpace(_ slot: SpaceSlot) {
        spaces.removeAll { $0.id == slot.id }
        if currentSpaceID == slot.spaceID {
            currentSpaceName = spaces.first?.name ?? "No Space"
        }
        saveSpaces()
    }
    
    // MARK: - Persistence
    
    func saveSpaces() {
        // Convert spaces to a simple array of dictionaries
        let data = spaces.map { slot in
            ["spaceID": slot.spaceID, "name": slot.name] as [String: Any]
        }
        UserDefaults.standard.set(data, forKey: "savedSpaces")
    }
    
    func loadSpaces() {
        guard let data = UserDefaults.standard.array(forKey: "savedSpaces")
                as? [[String: Any]] else { return }
        
        spaces = data.compactMap { dict in
            guard let spaceID = dict["spaceID"] as? Int,
                  let name = dict["name"] as? String else { return nil }
            return SpaceSlot(spaceID: spaceID, name: name)
        }
    }
}

struct SpaceSlot: Identifiable {
    let id = UUID()
    let spaceID: Int
    var name: String
}
