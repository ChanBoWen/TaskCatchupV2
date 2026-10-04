//
//  OnboardingViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import Foundation
import Combine
import CoreData

/// ViewModel responsible for managing the state and business logic for first-time user setup in the Onboarding Screen.
///
class OnboardingViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var showError: Bool = false
    
    private let repository: GoalRepository
    
    // Inject the Core Data repositories
    init(repository: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)) {
        self.repository = repository
    }
    
    // Creates the initial profile in Core Data
    func completeOnboarding(completion: @escaping () -> Void) {
        // Ensure a name is entered
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showError = true
            return
        }
        
        // Create the new profile with the user's name and new stat
        let newProfile = StudentProfile(
            name: trimmedName,
            balancePoints: 0,
            lifetimeXP: 0,
            currentLevel: 1,
            dailyStreak: 0
        )
        
        do {
            try repository.updateProfile(newProfile)
            completion()
        } catch {
            showError = true
        }
    }
}
