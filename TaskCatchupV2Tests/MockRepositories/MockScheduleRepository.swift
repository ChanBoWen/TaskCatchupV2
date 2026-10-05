//
//  MockScheduleRepository.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 5/10/2026.
//

import Foundation
@testable import TaskCatchupV2

/// A fake repository used for Unit Testing.
///
class MockScheduleRepository: ScheduleRepository {
    var dummySchedules: [DailySchedule] = []
    
    func fetchSchedules() throws -> [DailySchedule] { return dummySchedules }
    func updateSchedule(_ schedule: DailySchedule) throws { dummySchedules.append(schedule) }
    func deleteSchedule(byId id: UUID) throws { dummySchedules.removeAll { $0.id == id } }
}
