//
//  FeatureRowView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import SwiftUI

/// A reusable view representing the row component for displaying a feature icon, title, and description.
/// 
struct FeatureRowView: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(desc).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}
