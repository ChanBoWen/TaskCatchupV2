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
///
struct AddNewDailyGoalUseCase {
    func execute(title: String, category: DailyGoal.GoalCategory, isRecurring: Bool) throws -> DailyGoal {
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
        return DailyGoal(
            title: title,
            category: category,
            isRecurring: isRecurring,
            rewardPoints: rewardPoints
        )
    }
}
