//
//  AddNewGoalView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// A simple form sheet allowing the user to create a new Daily Goal.
///
struct AddNewGoalView: View {
    @ObservedObject var viewModel: DailyGoalsViewModel
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var selectedCategory: DailyGoal.GoalCategory = .academic  // Initial category showed
    @State private var isRecurring: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    // Naming the goal
                    TextField("Goal Title", text: $title)
                    
                    // Select the category for the goal
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(DailyGoal.GoalCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                // Setting for goal repeat
                Section(header: Text("Repeat")) {
                    Toggle("Repeat Every Day", isOn: $isRecurring)
                }
                
                // Explain the points system
                Section(footer: Text("Academic & Work goals yield 20 BP.\nSport yields 15 BP.\nSocial yields 10 BP.\nRest yields 5 BP.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Set a New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                // Exit the form
                leading: Button("Cancel") {
                    isPresented = false
                },
                // Add the new goal to the list
                trailing: Button("Add") {
                    viewModel.addNewGoal(title: title, category: selectedCategory, isRecurring: isRecurring)
                    // Only dismiss if successful
                    if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isPresented = false
                    }
                }
            )
            // Shows domain errors
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Whoops!"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred!"),
                    dismissButton: .default(Text("Got it"))
                )
            }
        }
    }
}
