//
//  RemoveDailyGoalUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. Removing a goal incurs a 20 BP penalty to discourage abandoning tasks, , unless a Free Delete Voucher is used.
/// 2. A user cannot delete a goal if they do not have enough BP to pay the penalty.
/// 3. If a completed goal is removed, the claimed XP is reverted.
///
struct RemoveDailyGoalUseCase {
    let removePenalty = 20
    
    func execute(goal: DailyGoal, profile: StudentProfile, useFreeDeleteVoucher: Bool) throws -> StudentProfile {
        var updatedProfile = profile
                
        if useFreeDeleteVoucher {
            // Use the voucher instead of BP
            guard let voucherIndex = updatedProfile.activeVouchers.firstIndex(of: .freeDelete) else {
                throw TaskCatchupError.missingVoucher(name: StudentProfile.VoucherType.freeDelete.rawValue)
            }
            
            // Consume the voucher
            updatedProfile.activeVouchers.remove(at: voucherIndex)
        } else {
            // Check whether enough points to decrease
            guard profile.balancePoints >= removePenalty else {
                throw TaskCatchupError.cannotAffordPenalty(penalty: removePenalty)
            }
            
            // Apply the penalty
            updatedProfile.balancePoints -= removePenalty
        }
        
        // If the goal was already ticked as completed, revert the gained XP
        if goal.isCompleted {
            updatedProfile.lifetimeXP = max(0, updatedProfile.lifetimeXP - goal.rewardPoints)
        }
        
        // Dynamic level calculation
        updatedProfile.currentLevel = (updatedProfile.lifetimeXP / 100) + 1
        
        // Return with the goal removed
        return updatedProfile
    }
}
