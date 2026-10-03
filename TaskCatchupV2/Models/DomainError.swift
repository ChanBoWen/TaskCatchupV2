//
//  DomainError.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// Represents domain-specific errors a student might encounter when managing and interacting with their daily schedule or goals.
/// These errors are designed to guide the human, not just crash the app.
///
enum TaskCatchupError: LocalizedError, Equatable {
    case cannotAffordPenalty(penalty: Int)
    case emptyGoalTitle
    case emptyScheduleTitle
    case insufficientBalance(shortage: Int)
    case scheduleConflict
    case databaseError(reason: String)
    case missingVoucher(name: String)
    
    var errorDescription: String? {
        switch self {
        case .cannotAffordPenalty(let penalty):
            return "You cannot perform this action right now. You need at least \(penalty) Balance Points to cover the penalty!"
        case .emptyGoalTitle:
            return "Your goal needs a clear title so you know exactly what to focus on."
        case .emptyScheduleTitle:
            return "Your event needs a clear title so you know exactly what to do."
        case .insufficientBalance(let shortage):
            return "You need \(shortage) more Balance Points to unlock this. Try completing more goals to earn more!"
        case .scheduleConflict:
            return "Double booking! You already have an event scheduled at this time. Try moving this new event to an available time block."
        case .databaseError(let reason):
            return "We had trouble saving your data: \(reason)."
        case .missingVoucher(let name):
            return "You don't have a \(name) in your inventory. Visit the Redeem tab to get one!"
        }
    }
}
