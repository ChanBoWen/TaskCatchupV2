//
//  DailyGoal.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// Represents a specific task or goal that a student sets to achieve in their day.
///
/// **Business Rules:**
/// 1. A goal must belong to a specific category, such as Academic, Work, Sport, Social, or Rest
/// 2. Completing a goal awards the student Balance Points and XP
/// 3. Goals can be one-off tasks or recurring daily habits.
///
struct DailyGoal: Identifiable, Equatable {
    let id: UUID
    var title: String
    var category: GoalCategory
    var isCompleted: Bool
    var isRecurring: Bool  // Set as one-time flexible task or daily habit
    var rewardPoints: Int  // The amount of Balance Points and XP awarded upon successful completion
    var createdAt: Date
    
    enum GoalCategory: String, CaseIterable {
        case academic = "Academic"
        case work = "Work"
        case sport = "Sport"
        case social = "Social"
        case rest = "Rest"
    }
    
    // Initialiser with default values
    init(id: UUID = UUID(), title: String, category: GoalCategory, isRecurring: Bool, isCompleted: Bool = false, rewardPoints: Int, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.category = category
        self.isRecurring = isRecurring
        self.isCompleted = isCompleted
        self.rewardPoints = rewardPoints
        self.createdAt = createdAt
    }
}
