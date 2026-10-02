//
//  DailySchedulesViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation
import Combine
import CoreData

/// ViewModel responsible for managing the state and business logic for the Daily Schedules screen.
///
class DailySchedulesViewModel: ObservableObject {
    @Published var profile: StudentProfile?
    @Published var todaySchedule: [DailySchedule] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let scheduleNewEventUseCase = ScheduleNewEventUseCase()
    private let profileRepo: GoalRepository
    private let scheduleRepo: ScheduleRepository
    
    // Inject the Core Data repositories
    init(
        scheduleRepo: ScheduleRepository = CoreDataScheduleRepository(context: PersistenceController.shared.container.viewContext),
        profileRepo: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)
    ) {
        self.scheduleRepo = scheduleRepo
        self.profileRepo = profileRepo
        loadData()
    }
    
    // Load the profile and events from Core Data
    func loadData() {
        do {
            self.profile = try profileRepo.fetchProfile()
            self.todaySchedule = try scheduleRepo.fetchSchedules()
        } catch {
            let fallback = TaskCatchupError.databaseError(reason: "Failed to load schedule data")
            self.errorMessage = fallback.localizedDescription
            self.showError = true
        }
    }
    
    // Adds a new event to the schedule
    func addEvent(title: String, startTime: Date, endTime: Date, category: DailySchedule.ScheduleCategory) {
        do {
            // Check for empty titles and double bookings
            let newEvent = try scheduleNewEventUseCase.execute(
                title: title,
                startTime: startTime,
                endTime: endTime,
                category: category,
                existingSchedule: todaySchedule
            )
            
            // Save the newest event to the database
            try scheduleRepo.updateSchedule(newEvent)
            
            // Reload from the database
            loadData()
        } catch let error as TaskCatchupError {
            self.errorMessage = error.localizedDescription
            self.showError = true
        } catch {
            let fallback = TaskCatchupError.databaseError(reason: "Failed to add event")
            self.errorMessage = fallback.localizedDescription
            self.showError = true
        }
    }
    
    // Removes a scheduled event
    func removeEvent(_ event: DailySchedule) {
        do {
            // Delete from the database
            try scheduleRepo.deleteSchedule(byId: event.id)
            
            // Reload from the database
            loadData()
        } catch {
            let fallback = TaskCatchupError.databaseError(reason: "Failed to delete event")
            self.errorMessage = fallback.localizedDescription
            self.showError = true
        }
    }
}
