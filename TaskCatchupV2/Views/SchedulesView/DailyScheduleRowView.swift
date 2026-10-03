//
//  DailyScheduleRowView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// A reusable view representing a single scheduled event on the daily timeline.
/// Includes the delete button.
///
struct DailyScheduleRowView: View {
    let event: DailySchedule
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // Event time
            VStack(alignment: .trailing, spacing: 2) {
                Text(event.startTime, style: .time)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
                
                Text("–")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                
                Text(event.endTime, style: .time)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
            }
            .frame(width: 70, alignment: .trailing)
            
            // Subtle divider
            Rectangle()
                .fill(.blue.opacity(0.3))
                .frame(width: 3)
                .cornerRadius(1.5)
    
            // Event details
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.headline)
                
                Text(event.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Delete event button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    DailyScheduleRowView(
        event: DailySchedule(title: "Biology Lecture", startTime: Date(), endTime: Date().addingTimeInterval(3600), category: .academic),
        onDelete: {}
    )
}
