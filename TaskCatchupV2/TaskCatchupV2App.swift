//
//  TaskCatchupV2App.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 1/10/2026.
//

import SwiftUI
import CoreData

@main
struct TaskCatchupV2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
