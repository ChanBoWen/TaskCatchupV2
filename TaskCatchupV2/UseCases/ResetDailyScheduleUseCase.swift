//
//  ResetDailyScheduleUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. Any fixed schedule event whose end time has passed into a previous day is considered expired.
/// 2. Expired events are removed from the timeline for the current day.
///
struct ResetDailyScheduleUseCase {
    func execute(currentSchedules: [DailySchedule]) -> [DailySchedule] {
        var schedulesToDelete: [DailySchedule] = []
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        for schedule in currentSchedules {
            // The event is expired if it is ended before the beginning of today
            if schedule.endTime < startOfToday {
                schedulesToDelete.append(schedule)
            }
        }
        
        return schedulesToDelete
    }
}
