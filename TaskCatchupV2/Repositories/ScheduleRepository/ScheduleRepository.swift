//
//  ScheduleRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// A protocol defining the data access rules for Daily Schedules.
///

protocol ScheduleRepository {
    func fetchSchedules() throws -> [DailySchedule]
    func updateSchedule(_ schedule: DailySchedule) throws
    func deleteSchedule(byId id: UUID) throws
}
