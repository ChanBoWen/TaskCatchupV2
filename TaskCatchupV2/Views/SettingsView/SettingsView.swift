//
//  SettingsView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import SwiftUI

/// Displays the app settings.
///
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                // Header section
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(.top, 8)
                        
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                
                // Notifications section
                Section {
                    Toggle(isOn: $viewModel.isReminderEnabled) {
                        Label {
                            Text("Daily Planning Reminder")
                        } icon: {
                            Image(systemName: "bell.badge.fill")
                                .foregroundStyle(.orange)
                        }
                    }
                    .tint(.orange)
                    
                    if viewModel.isReminderEnabled {
                        DatePicker(
                            selection: $viewModel.reminderTime,
                            displayedComponents: .hourAndMinute
                        ) {
                            Label {
                                Text("Reminder Time")
                            } icon: {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("When enabled, a rich notification will remind you to set your goals.\nLong-press the notification to see your current stats.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .animation(.easeInOut(duration: 0.25), value: viewModel.isReminderEnabled)
                
                // About section
                Section {
                    HStack {
                        Label {
                            Text("Current Version")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("2.0")
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                } header: {
                    Text("About")
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
