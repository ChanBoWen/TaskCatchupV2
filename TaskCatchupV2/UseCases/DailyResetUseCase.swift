//
//  DailyResetUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. One-off goals expire and are removed from the active list when a new day begins.
/// 2. Recurring goals stay on the schedule but are reset to incomplete when a new day begins.
///
struct DailyResetUseCase {
    func execute(currentGoals: [DailyGoal]) -> (goalsToDelete: [DailyGoal], goalsToReset: [DailyGoal]) {
        var goalsToDelete: [DailyGoal] = []
        var goalsToReset: [DailyGoal] = []
        
        for goal in currentGoals {
            if !goal.isRecurring {
                // Remove one-off goals
                goalsToDelete.append(goal)
            } else {
                // Reset recurring goals to incomplete
                if goal.isCompleted {
                    var resetGoal = goal
                    resetGoal.isCompleted = false
                    goalsToReset.append(resetGoal)
                }
            }
        }
        
        return (goalsToDelete, goalsToReset)
    }
}
