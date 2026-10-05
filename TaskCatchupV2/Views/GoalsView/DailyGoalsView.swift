//
//  DailyGoalsView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// Displays the student's daily goals.
///
struct DailyGoalsView: View {
    @StateObject private var viewModel = DailyGoalsViewModel()
    
    @State private var showingAddGoalForm = false
    @State private var goalToDelete: DailyGoal? = nil
    @State private var goalToUntick: DailyGoal? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            // Top bar
            if let profile = viewModel.profile {
                TopBarView(profile: profile)
            } else {
                // Shows a spinner while loading
                ProgressView("Loading Profile...")
            }
            
            Spacer()
            
            // Header
            HStack {
                Text("My Today's Goals")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Add new goal button
                Button(action: {
                    showingAddGoalForm = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Daily goals list
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.todayGoals) { goal in
                        // Extracted goal row view
                        DailyGoalRowView(
                            goal: goal,
                            onToggle: {
                                // Check whther if the goal has already been ticked
                                if goal.isCompleted {
                                    goalToUntick = goal
                                } else {
                                    // Ask confirmation to untick
                                    viewModel.toggleGoal(goal)
                                }
                            },
                            onDelete: {
                                goalToDelete = goal
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
        
        // Opens the add goal sheet
        .sheet(isPresented: $showingAddGoalForm) {
            AddNewGoalView(viewModel: viewModel, isPresented: $showingAddGoalForm)
        }
        
        // Opens the delete confirmation
        .alert("Delete Goal?", isPresented: Binding(
            get: { goalToDelete != nil },
            set: { if !$0 { goalToDelete = nil } }
        )
        ) {
            // Dynamically show the use voucher button only if available
            if let profile = viewModel.profile, profile.activeVouchers.contains(.freeDelete) {
                Button("Use Free Delete Voucher", role: .none) {
                    if let goal = goalToDelete {
                        viewModel.removeGoal(goal, useFreeDeleteVoucher: true)
                    }
                    goalToDelete = nil
                }
            }
            
            Button("Delete this Goal", role: .destructive) {
                if let goal = goalToDelete {
                    viewModel.removeGoal(goal)
                }
                goalToDelete = nil
            }
            
            Button("Cancel", role: .cancel) {
                goalToDelete = nil
            }
        } message: {
            Text("Are you sure? Deleting a goal incurs a 20 BP penalty.")
        }
        
        // Opens the untick confirmation
        .alert("Untick Goal?", isPresented: Binding(
            get: { goalToUntick != nil },
            set: { if !$0 { goalToUntick = nil } }
        )
        ) {
            Button("Untick this Goal", role: .destructive) {
                if let goal = goalToUntick {
                    viewModel.toggleGoal(goal)
                }
                goalToUntick = nil
            }
            Button("Cancel", role: .cancel) {
                goalToUntick = nil
            }
        } message: {
            Text("Are you sure? Unticking a completed goal incurs a 20 BP penalty.")
        }
        
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    DailyGoalsView()
}

