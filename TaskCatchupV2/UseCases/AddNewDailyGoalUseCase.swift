//
//  AddNewDailyGoalUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. A goal must have a valid, non-empty title.
/// 2. The system automatically assigns base reward points based on the goal's category.
/// 3. If the user already achieved a "perfect day" streak today, adding a new incomplete goal revokes the streak until this new goal is also completed.
///
struct AddNewDailyGoalUseCase {
    func execute(title: String, category: DailyGoal.GoalCategory, isRecurring: Bool, profile: StudentProfile) throws -> (newGoal: DailyGoal, updatedProfile: StudentProfile) {
        // Validate title
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TaskCatchupError.emptyGoalTitle
        }
        
        // Assign category-specific reward points
        let rewardPoints: Int
        switch category {
        case .academic, .work:
            rewardPoints = 20
        case .sport:
            rewardPoints = 15
        case .social:
            rewardPoints = 10
        case .rest:
            rewardPoints = 5
        }
        
        // Create the new goal
        let newGoal = DailyGoal(title: title, category: category, isRecurring: isRecurring, rewardPoints: rewardPoints)
        
        var updatedProfile = profile
        let calendar = Calendar.current
        
        if let lastDate = updatedProfile.lastStreakDate, calendar.isDateInToday(lastDate) {
            // Revoke the streak point
            updatedProfile.dailyStreak = max(0, updatedProfile.dailyStreak - 1)
            
            // Set the streak date back to yesterday
            updatedProfile.lastStreakDate = calendar.date(byAdding: .day, value: -1, to: Date())
        }
        
        return (newGoal, updatedProfile)
    }
}
