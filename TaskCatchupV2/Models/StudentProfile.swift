//
//  StudentProfile.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import Foundation

/// Represents the student's current wellbeing metrics, progress, and available rewards.
///
/// **Business Rules:**
/// 1. Balance Points (BP) are used as currency and cannot drop below zero.
/// 2. Lifetime XP determines the user's Level and Progress Bar.
/// 3. Level represents lifetime progression and never decreases.
/// 4. Daily Streak resets if the student goes a full day without completing a goal
///
struct StudentProfile: Equatable {
    let id: UUID
    var name: String
    var balancePoints: Int
    var lifetimeXP: Int
    var currentLevel: Int
    var dailyStreak: Int  // The number of consecutive days the student has completed all their set goals
    var activeVouchers: [VoucherType]  // How much active boost cards or vouchers the student has
    
    enum VoucherType: String, Equatable, Codable {
        case doubleXP = "Double XP Boost"
        case doubleBP = "Double BP Boost"
        case restDay = "Rest Day Pass"
        case freeDelete = "Free Delete Voucher"
    }
    
    // Initialiser with default values
    init(id: UUID = UUID(), name: String, balancePoints: Int = 0, lifetimeXP: Int = 0, currentLevel: Int = 1, dailyStreak: Int = 0, activeVouchers: [VoucherType] = []) {
        self.id = id
        self.name = name
        self.balancePoints = balancePoints
        self.lifetimeXP = lifetimeXP
        self.currentLevel = currentLevel
        self.dailyStreak = dailyStreak
        self.activeVouchers = activeVouchers
    }
}
