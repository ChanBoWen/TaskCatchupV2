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
    
    // Checks the device to see if this is the first time opening the app
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
            }
        }
    }
}
