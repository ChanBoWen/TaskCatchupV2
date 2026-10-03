//
//  StoreItemCardView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import SwiftUI

/// A reusable view with grid card representing a single voucher in the store.
/// Includes the redeem button.
///
struct StoreItemCardView: View {
    let item: StoreItem
    let onRedeem: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            // Voucher icon
            Image(systemName: item.icon)
                .font(.system(size: 35))
                .foregroundColor(item.color)
                .padding(.top, 10)
            
            // Voucher name
            Text(item.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            // Description
            Text(item.description)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .frame(height: 30)
            
            // Cost
            Text("Cost: \(item.cost) BP")
                .font(.subheadline)
                .foregroundColor(.orange)
                .fontWeight(.bold)
                .padding(.vertical, 4)
            
            // Purchase voucher button
            Button(action: onRedeem) {
                Text("Redeem")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}
