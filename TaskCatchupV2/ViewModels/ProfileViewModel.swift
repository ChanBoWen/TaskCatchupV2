//
//  ProfileViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import Foundation
import Combine
import CoreData

/// ViewModel responsible for managing the state and business logic of the Profile Screen.
///
class ProfileViewModel: ObservableObject {
    @Published var profile: StudentProfile?
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let repository: GoalRepository
    
    init(repository: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)) {
        self.repository = repository
        loadData()
    }
    
    // Load the profile from Core Data
    func loadData() {
        do {
            self.profile = try repository.fetchProfile()
        } catch {
            let fallback = TaskCatchupError.databaseError(reason: "Failed to load profile stats")
            self.errorMessage = fallback.localizedDescription
            self.showError = true
        }
    }
}
