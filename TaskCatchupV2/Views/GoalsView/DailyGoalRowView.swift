//
//  DailyGoalRowView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// A reusable view representing a single row in the Daily Goals list.
/// Includes the checkbox button and delete button.
///
struct DailyGoalRowView: View {
    let goal: DailyGoal
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // Checkbox button
            Button(action: onToggle) {
                Image(systemName: goal.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(goal.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            // Goal's title
            Text(goal.title)
                .strikethrough(goal.isCompleted, color: .gray)
                .font(.headline)
                .foregroundColor(goal.isCompleted ? .gray : .primary)
            
            Spacer()
            
            // Reward points
            Text("+\(goal.rewardPoints) points")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .overlay(
                    Rectangle().stroke(Color.gray, lineWidth: 1)
                )
                .foregroundColor(goal.isCompleted ? .gray : .primary)
            
            // Delete goal button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.title3)
                    .padding(.leading, 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
}

