//
//  AddNewScheduleView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// A simple form sheet allowing the user to schedule a new daily event.
///
struct AddNewScheduleView: View {
    @ObservedObject var viewModel: DailySchedulesViewModel
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var selectedCategory: DailySchedule.ScheduleCategory = .academic
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    
    // Variable to set exactly 11:59 PM
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    // Naming the event
                    TextField("Event Title", text: $title)
                    
                    // Select the category for the goal
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(DailySchedule.ScheduleCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                // Set the time
                // Adjust the starting and ending time
                Section(header: Text("Set Time"), footer: Text("Events must be scheduled for today and cannot be in the past.")) {
                    // Start Time: must be after now
                    DatePicker("Start Time", selection: $startTime, in: Date()...endOfDay, displayedComponents: .hourAndMinute)
                        .onChange(of: startTime) { oldValue, newValue in
                            if endTime < newValue {
                                endTime = newValue
                            }
                        }
                    
                    // End Time: must be after startTime and no later than 23:59 today
                    DatePicker("End Time", selection: $endTime, in: startTime...endOfDay, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Create a New Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                // Exit the form
                leading: Button("Cancel") {
                    isPresented = false
                },
                // Add the new event to the schedule
                trailing: Button("Add") {
                    // Reset error state before trying
                    viewModel.showError = false
                    
                    // Try to add the event
                    viewModel.addEvent(title: title, startTime: startTime, endTime: endTime, category: selectedCategory)
                    
                    // Only dismiss if successful
                    if !viewModel.showError { isPresented = false }
                }
            )
            
            // Shows domain errors
            .alert("Whoops!", isPresented: $viewModel.showError) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred!")
            }
        }
    }
}

#Preview {
    DailySchedulesView()
}
