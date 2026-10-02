//
//  GoalRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// A protocol defining the data access rules for Daily Goals.
///
protocol GoalRepository {
    func fetchProfile() throws -> StudentProfile
    func updateProfile(_ profile: StudentProfile) throws
    
    func fetchGoals() throws -> [DailyGoal]
    func fetchIncompleteGoals() throws -> [DailyGoal]
    func addGoal(_ goal: DailyGoal) throws
    func updateGoal(_ goal: DailyGoal) throws
    func deleteGoal(byId id: UUID) throws
}
