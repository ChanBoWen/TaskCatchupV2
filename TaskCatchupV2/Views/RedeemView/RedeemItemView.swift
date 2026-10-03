//
//  RedeemItemView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// The store screen where users can spend Balance Points on rewards.
///
struct RedeemItemView: View {
    @StateObject private var viewModel = RedeemItemViewModel()
    
    // Displays vouchers in two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                Text("Available Vouchers")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Displays available vourchers to redeem in columns
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.storeItems) { item in
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
                            Button(action: {
                                viewModel.purchaseVoucher(type: item.type, cost: item.cost, itemName: item.title)
                            }) {
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
                .padding(.horizontal)
            }
        }
        // Shows domain errors
        .alert("Whoops!", isPresented: $viewModel.showError) {
            Button("Got it", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
        
        // Show success message if successfully redeemed
        .alert("Success!", isPresented: $viewModel.showSuccess) {
            Button("Awesome", role: .cancel) { }
        } message: {
            Text(viewModel.successMessage)
        }
    }
}

#Preview {
    RedeemItemView()
}
