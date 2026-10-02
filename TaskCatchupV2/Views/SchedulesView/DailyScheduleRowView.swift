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
            Text(event.startTime, style: .time)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .frame(width: 75, alignment: .leading)
    
            // Event details
            VStack(alignment: .leading) {
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
