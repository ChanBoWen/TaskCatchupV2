//
//  SettingsViewModel.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel responsible for managing the state and business logic for the Settings screen.
///
class SettingsViewModel: ObservableObject {
    @Published var isReminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isReminderEnabled, forKey: "isReminderEnabled")
            updateNotificationStatus()
        }
    }
    
    @Published var reminderTime: Date {
        didSet {
            UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
            if isReminderEnabled {
                updateNotificationStatus()
            }
        }
    }
    
    @Published var showPermissionError: Bool = false
    
    private let manageReminderUseCase = ManageDailyReminderUseCase()
    
    init() {
        // Load saved preferences
        self.isReminderEnabled = UserDefaults.standard.bool(forKey: "isReminderEnabled")
        
        if let savedDate = UserDefaults.standard.object(forKey: "reminderTime") as? Date {
            self.reminderTime = savedDate
        } else {
            // Use 8:00 AM for default if none is chosen
            self.reminderTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
        }
    }
    
    private func updateNotificationStatus() {
        if isReminderEnabled {
            Task {
                do {
                    let success = try await manageReminderUseCase.scheduleReminder(at: reminderTime)
                    
                    if !success {
                        // Force the toggle back off
                        self.isReminderEnabled = false
                        
                        // Show the alert telling them to go to the iOS Settings app
                        self.showPermissionError = true
                    }
                } catch {
                    self.isReminderEnabled = false
                }
            }
        } else {
            manageReminderUseCase.cancelReminder()
        }
    }
}
