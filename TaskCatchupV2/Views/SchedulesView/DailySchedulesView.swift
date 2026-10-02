//
//  DailySchedulesView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// Displays the student's daily scheduled events.
///
struct DailySchedulesView: View {
    @StateObject private var viewModel = DailySchedulesViewModel()
    
    @State private var showingAddEventForm = false
    @State private var eventToDelete: DailySchedule? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            // Top bar
            if let profile = viewModel.profile {
                TopBarView(profile: profile)
            } else {
                // Shows a spinner while loading
                ProgressView("Loading Profile...")
                    .padding(.top, 40)
            }

            Spacer()
            
            // Header
            HStack {
                Text("My Today's Schedule")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Add new event button
                Button(action: {
                    showingAddEventForm = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Scheduled event list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.todaySchedule) { event in
                        // Extracted scheduled event row view
                        DailyScheduleRowView(
                            event: event,
                            onDelete: {
                                eventToDelete = event
                            }
                        )
                    }
                }
                .padding(.bottom, 20)
            }
        }
        // Shows domain errors
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Whoops!"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred!"),
                dismissButton: .default(Text("Got it"))
            )
        }
        
        // Opens the add event sheet
        .sheet(isPresented: $showingAddEventForm) {
            AddNewScheduleView(viewModel: viewModel, isPresented: $showingAddEventForm)
        }
        
        // Opens the delete confirmation
        .alert("Delete Event?", isPresented: Binding(
            get: { eventToDelete != nil },
            set: { if !$0 { eventToDelete = nil } }
        )
        ) {
            Button("Delete this Event", role: .destructive) {
                if let event = eventToDelete {
                    viewModel.removeEvent(event)
                }
                eventToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                eventToDelete = nil
            }
        } message: {
            Text("Are you sure you want to remove this event from your schedule?")
        }
    }
}

#Preview {
    DailySchedulesView()
}
