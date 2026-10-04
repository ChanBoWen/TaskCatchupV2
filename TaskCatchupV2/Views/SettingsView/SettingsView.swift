//
//  SettingsView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import SwiftUI

/// Displays  the app settings.
///
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
        
        Form {
            Section(header: Text("Notifications"), footer: Text("When turned on, a rich notification will be send to remind you to set your goals.\nLong-press the notification to see your current stats!")) {
                
                // Button to turn the notification on
                Toggle("Daily Planning Reminder", isOn: $viewModel.isReminderEnabled)
                
                // Select the time to receive notification
                if viewModel.isReminderEnabled {
                    DatePicker("Reminder Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("2.0 (A3)")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
