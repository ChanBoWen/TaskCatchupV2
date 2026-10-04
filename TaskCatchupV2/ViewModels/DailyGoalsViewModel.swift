//
//  DailyGoalsViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import Combine
import CoreData
import WidgetKit

/// ViewModel responsible for managing the state and business logic of the Daily Goals screen.
///
class DailyGoalsViewModel: ObservableObject {
    @Published var profile: StudentProfile?
    @Published var todayGoals: [DailyGoal] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let repository: GoalRepository
    private let toggleGoalUseCase = ToggleGoalCompletionUseCase()
    private let addGoalUseCase = AddNewDailyGoalUseCase()
    private let removeGoalUseCase = RemoveDailyGoalUseCase()
    private let dailyResetUseCase = DailyResetUseCase()
    
    // Inject the Core Data repository
    init(repository: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)) {
        self.repository = repository
        loadData()
    }
    
    // Load the profile and goals from Core Data
    func loadData() {
        do {
            self.profile = try repository.fetchProfile()
            self.todayGoals = try repository.fetchGoals()
            
            checkAndPerformDailyReset()
        } catch {
            let fallbackError = TaskCatchupError.databaseError(reason: "An unexpected system error occurred")
            self.errorMessage = fallbackError.localizedDescription
            self.showError = true
        }
    }
    
    // Toggles the completion status of a goal and updates the student's profile
    func toggleGoal(_ goal: DailyGoal) {
        guard let currentProfile = profile else { return }
        
        do {
            // Execute the business rules
            let result = try toggleGoalUseCase.execute(goal: goal, profile: currentProfile, allDailyGoals: todayGoals)
            
            // Save both the updated goal and the updated profile to Core Data
            try repository.updateGoal(result.updatedGoal)
            try repository.updateProfile(result.updatedProfile)
            
            // Reload from the database
            loadData()
            
            // Reload the widget
            WidgetCenter.shared.reloadAllTimelines()
        } catch let error as TaskCatchupError {
            // Show error if cannot afford penalty
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            let fallbackError = TaskCatchupError.databaseError(reason: "Failed to update goal")
            self.errorMessage = fallbackError.localizedDescription
            self.showError = true
        }
    }
    
    // Adds a new goal to today's list
    func addNewGoal(title: String, category: DailyGoal.GoalCategory, isRecurring: Bool) {
        guard let currentProfile = profile else { return }
        
        do {
            // Save the newest goal to the database
            let result = try addGoalUseCase.execute(title: title, category: category, isRecurring: isRecurring, profile: currentProfile)
            
            // Save the new goal AND the updated profile to Core Data
            try repository.addGoal(result.newGoal)
            try repository.updateProfile(result.updatedProfile)
            
            // Reload from the database
            loadData()
            
            // Reload the widget
            WidgetCenter.shared.reloadAllTimelines()
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            let fallbackError = TaskCatchupError.databaseError(reason: "Failed to add goal")
            self.errorMessage = fallbackError.localizedDescription
            self.showError = true
        }
    }
    
    // Removes a goal and applies the penalty
    func removeGoal(_ goal: DailyGoal, useFreeDeleteVoucher: Bool = false) {
        guard let currentProfile = profile else { return }
        
        do {
            let updatedProfile = try removeGoalUseCase.execute(goal: goal, profile: currentProfile, useFreeDeleteVoucher: useFreeDeleteVoucher)
            
            // Delete the goal and update the profile penalty in Core Data
            try repository.deleteGoal(byId: goal.id)
            try repository.updateProfile(updatedProfile)
            
            // Reload from the database
            loadData()
            
            // Reload the widget
            WidgetCenter.shared.reloadAllTimelines()
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            let fallbackError = TaskCatchupError.databaseError(reason: "Failed to delete goal")
            self.errorMessage = fallbackError.localizedDescription
            self.showError = true
        }
    }

    // Checks if a new day has started, and resets recurring goals and clears expired ones
    private func checkAndPerformDailyReset() {
        // Get the last time the app was opened
        let lastResetDate = UserDefaults.standard.object(forKey: "LastResetDate") as? Date ?? Date()
        
        // It is a new day if the last reset date is not today
        if !Calendar.current.isDateInToday(lastResetDate) {
            let result = dailyResetUseCase.execute(currentGoals: todayGoals)
            
            do {
                // Delete one-off goals from Core Data
                for goal in result.goalsToDelete {
                    try repository.deleteGoal(byId: goal.id)
                }
                
                // Untick recurring goals in Core Data
                for goal in result.goalsToReset {
                    try repository.updateGoal(goal)
                }
                
                // Save the new today's date
                UserDefaults.standard.set(Date(), forKey: "LastResetDate")
                
                // Reload the new goal list
                self.todayGoals = try repository.fetchGoals()
            } catch {
                print("Failed to perform daily reset.")
            }
        }
    }
}
