//
//  ManageDailyReminderUseCase.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import Foundation
import UserNotifications

/// **Business Rules:**
/// 1. The notification helps prevent streak loss by notifying the student to plan their day.
/// 2. It requires system permission to send notifications.
/// 
struct ManageDailyReminderUseCase {
    // Requests permission and schedules the daily reminder at the specified time
    func scheduleReminder(at time: Date) async throws -> Bool  {
        let centre = UNUserNotificationCenter.current()
        
        // Check current permission status
        let settings = await centre.notificationSettings()
        
        // Request permission from the user
        if settings.authorizationStatus == .notDetermined {
            // First time asking!
            let granted = try await centre.requestAuthorization(options: [.alert, .sound, .badge])
            
            // User clicked "Don't Allow"
            guard granted else { return false }
        } else if settings.authorizationStatus == .denied {
            return false
        }
        
        // Clear any old reminders
        centre.removeAllPendingNotificationRequests()
        
        // Create the Notification Content
        let content = UNMutableNotificationContent()
        content.title = "Plan Your Day!"
        content.body = "Open TaskCatchup to crush today's goals and maintain your streak."
        content.sound = .default
        content.categoryIdentifier = "DailyReminderCategory"
        
        // Extract the time from the Date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        // Schedule it to repeat daily at that exact time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_planning_reminder", content: content, trigger: trigger)
        
        try await centre.add(request)
        return true
    }
    
    // Cancels the daily reminder if turned off
    func cancelReminder() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
