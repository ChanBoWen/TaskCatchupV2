//
//  ScheduleNewEventUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. An event must have a valid, non-empty title.
/// 2. An event cannot overlap with an existing scheduled event.
///
struct ScheduleNewEventUseCase {
    func execute(title: String, startTime: Date, endTime: Date, category: DailySchedule.ScheduleCategory, existingSchedule: [DailySchedule]) throws -> DailySchedule {
        // Validate title
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TaskCatchupError.emptyScheduleTitle
        }
        
        // Check for time conflicts
        let hasConflict = existingSchedule.contains { existingEvent in
            return startTime < existingEvent.endTime && endTime > existingEvent.startTime
        }
        
        // Throws an error if time conflicted
        guard !hasConflict else {
            throw TaskCatchupError.scheduleConflict
        }
        
        // Create the new event to schedule
        return DailySchedule(
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category
        )
    }
}
