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
                Section(header: Text("Set Time")) {
                    // Adjust the starting and ending time
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
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
