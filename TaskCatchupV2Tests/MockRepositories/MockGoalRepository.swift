//
//  MockGoalRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 5/10/2026.
//

import Foundation
@testable import TaskCatchupV2

/// A fake repository used for Unit Testing.
///
class MockGoalRepository: GoalRepository {
    var dummyProfile = StudentProfile(name: "TestUser", balancePoints: 100, lifetimeXP: 200, currentLevel: 3, dailyStreak: 5, activeVouchers: [.freeDelete])
    var dummyGoals: [DailyGoal] = []
    
    func fetchProfile() throws -> StudentProfile { return dummyProfile }
    func updateProfile(_ profile: StudentProfile) throws { dummyProfile = profile }
    
    func fetchGoals() throws -> [DailyGoal] { return dummyGoals }
    func fetchIncompleteGoals() throws -> [DailyGoal] { return dummyGoals.filter { !$0.isCompleted } }
    
    func addGoal(_ goal: DailyGoal) throws { dummyGoals.append(goal) }
    func updateGoal(_ goal: DailyGoal) throws {
        if let idx = dummyGoals.firstIndex(where: { $0.id == goal.id }) { dummyGoals[idx] = goal }
    }
    func deleteGoal(byId id: UUID) throws { dummyGoals.removeAll { $0.id == id } }
}
