//
//  PurchaseVoucherUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// **Business Rules:**
/// 1. A student must have enough Balance Points to buy the voucher.
/// 2. If they cannot afford it, an error is thrown to guide them to earn more.
/// 3. Successful purchases deduct the points and add the voucher to their inventory.
///
struct PurchaseVoucherUseCase {
    func execute(voucher: StudentProfile.VoucherType, cost: Int, profile: StudentProfile) throws -> StudentProfile {
        // Check if the user can buy it
        guard profile.balancePoints >= cost else {
            // Calculate the exact shortage so user knows how much they lack
            let shortage = cost - profile.balancePoints
            throw TaskCatchupError.insufficientBalance(shortage: shortage)
        }
        
        // Process the transaction
        var updatedProfile = profile
        updatedProfile.balancePoints -= cost  // Deduct the cost from the balance
        updatedProfile.activeVouchers.append(voucher)
        
        return updatedProfile
    }
}
