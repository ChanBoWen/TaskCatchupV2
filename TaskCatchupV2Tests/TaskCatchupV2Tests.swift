//
//  TaskCatchupV2Tests.swift
//  TaskCatchupV2Tests
//
//  Created by Bo Wen Chan on 1/10/2026.
//

import Testing
@testable import TaskCatchupV2
import Foundation

struct TaskCatchupTests {
    
    // AddNewDailyGoalUseCase Tests
    @Test func test_addGoal_fails_whenTitleIsEmpty() {
        let useCase = AddNewDailyGoalUseCase()
        
        // Setup a dummy profile for the test
        let profile = StudentProfile(name: "Alex", balancePoints: 10, lifetimeXP: 20, currentLevel: 1, dailyStreak: 0)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.emptyGoalTitle) {
            // Try to set a new goal with just spaces
            try useCase.execute(title: "   ", category: .academic, isRecurring: false, profile: profile)
        }
    }
    
    // ToggleGoalCompletionUseCase Tests
    @Test func test_toggleGoal_succeeds_andAwardsPointsWhenGoalCompleted() throws {
        let useCase = ToggleGoalCompletionUseCase()
        
        // Sample data for testing
        let profile = StudentProfile(name: "Alex", balancePoints: 10, lifetimeXP: 20, currentLevel: 1, dailyStreak: 0)
        let goal = DailyGoal(title: "Read Book", category: .academic, isRecurring: false, rewardPoints: 20)
        
        let result = try useCase.execute(goal: goal, profile: profile, allDailyGoals: [goal])
        
        #expect(result.updatedGoal.isCompleted == true)
        #expect(result.updatedProfile.balancePoints == 30)  // If plus 20 successfully
        #expect(result.updatedProfile.lifetimeXP == 40)  // If plus 20 successfully
    }
    
    // ToggleGoalCompletionUseCase Tests
    @Test func test_toggleGoal_fails_whenUntickingWithInsufficientBP() {
        let useCase = ToggleGoalCompletionUseCase()
        
        // Sample data for testing
        // Set as completed, and 0 BP to test
        let profile = StudentProfile(name: "Alex", balancePoints: 0, lifetimeXP: 100, currentLevel: 2, dailyStreak: 1)
        var completedGoal = DailyGoal(title: "Read Book", category: .academic, isRecurring: false, rewardPoints: 20)
        completedGoal.isCompleted = true
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.cannotAffordPenalty(penalty: 20)) {
            try useCase.execute(goal: completedGoal, profile: profile, allDailyGoals: [completedGoal])
        }
    }
    
    // RemoveDailyGoalUseCase Tests
    @Test func test_removeGoal_fails_whenBPIsTooLowToCoverPenalty() {
        let useCase = RemoveDailyGoalUseCase()
        
        // Sample data for testing
        // Set as 10 BP because less than the 20 BP penalty
        let profile = StudentProfile(name: "Alex", balancePoints: 10)
        let goal = DailyGoal(title: "Gym for 1 hour", category: .sport, isRecurring: true, rewardPoints: 15)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.cannotAffordPenalty(penalty: 20)) {
            try useCase.execute(goal: goal, profile: profile, useFreeDeleteVoucher: false)
        }
    }
    
    // RemoveDailyGoalUseCase Tests
    @Test func test_removeGoal_succeeds_andDeductsPenaltyFromBalance() throws {
        let useCase = RemoveDailyGoalUseCase()
        
        // Sample data for testing
        let profile = StudentProfile(name: "Alex", balancePoints: 50)
        let goal = DailyGoal(title: "Gym", category: .sport, isRecurring: true, rewardPoints: 15)
        
        let result = try useCase.execute(goal: goal, profile: profile, useFreeDeleteVoucher: false)
        
        #expect(result.balancePoints == 30)  // Minus 20
    }
    
    // RemoveDailyGoalUseCase Tests
    @Test func test_removeGoal_usingFreeDeleteVoucher() throws {
        let useCase = RemoveDailyGoalUseCase()
        
        // Sample data for testing
        let profile = StudentProfile(name: "Alex", balancePoints: 50, activeVouchers: [.freeDelete])
        let goal = DailyGoal(title: "Gym", category: .sport, isRecurring: true, rewardPoints: 15)
        
        // Use the voucher to delete the goal
        let result = try useCase.execute(goal: goal, profile: profile, useFreeDeleteVoucher: true)
        
        #expect(result.balancePoints == 50)  // No BP is deducted
        #expect(result.activeVouchers.isEmpty == true)  // Voucher is consumed
    }
    
    // AddNewDailyGoalUseCase to repository Tests
    @MainActor
    @Test func test_addsGoal_toRepository() {
        // Use the mock repo
        let mockRepo = MockGoalRepository()
        let viewModel = DailyGoalsViewModel(repository: mockRepo)
        
        // User sets a new goal
        viewModel.addNewGoal(title: "Pass Assignment 2", category: .academic, isRecurring: false)
        
        #expect(viewModel.todayGoals.count == 1)
        #expect(viewModel.todayGoals.last?.title == "Pass Assignment 2")
        
        let savedGoals = try? mockRepo.fetchGoals()
        #expect(savedGoals?.count == 1)
    }
    
    // ScheduleNewEventUseCase Tests
    @Test func test_scheduleEvent_fails_whenTitleIsEmpty() {
        let useCase = ScheduleNewEventUseCase()
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.emptyScheduleTitle) {
            // Try to schedule an event with just spaces
            try useCase.execute(title: "   ", startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .academic, existingSchedule: [])
        }
    }
    
    // ScheduleNewEventUseCase Tests
    @Test func test_scheduleEvent_fails_whenTimeConflicts() {
        let useCase = ScheduleNewEventUseCase()
        let baseTime = Date()
        
        // Existing event that has been set
        let existingEvent = DailySchedule(title: "Math Class", startTime: baseTime, endTime: baseTime.addingTimeInterval(3600), category: .academic)
        
        // Assert that it throws the expected domain error
        #expect(throws: TaskCatchupError.scheduleConflict) {
            // Try to set an overlapping event
            try useCase.execute(title: "Work Shift", startTime: baseTime.addingTimeInterval(1800), endTime: baseTime.addingTimeInterval(5400), category: .work, existingSchedule: [existingEvent])
        }
    }
    
    // ScheduleNewEventUseCase to repository Tests
    @MainActor
    @Test func test_addsSchedule_toRepository() {
        // Use the mock repo
        let mockScheduleRepo = MockScheduleRepository()
        let mockGoalRepo = MockGoalRepository()
        let viewModel = DailySchedulesViewModel(scheduleRepo: mockScheduleRepo, profileRepo: mockGoalRepo)
        
        // 0 event initially
        let initialCount = (try? mockScheduleRepo.fetchSchedules().count) ?? 0
        
        // Schedule a future event
        let futureStart = Date().addingTimeInterval(86400 * 10)
        let futureEnd = futureStart.addingTimeInterval(3600)
        
        // User set a new event
        viewModel.addEvent(title: "Future Exam", startTime: futureStart, endTime: futureEnd, category: .academic)
        
        #expect(viewModel.todaySchedule.count == initialCount + 1)
        
        let savedSchedules = try? mockScheduleRepo.fetchSchedules()
        #expect(savedSchedules?.count == initialCount + 1)
        #expect(savedSchedules?.contains(where: { $0.title == "Future Exam" }) == true)
    }
}
