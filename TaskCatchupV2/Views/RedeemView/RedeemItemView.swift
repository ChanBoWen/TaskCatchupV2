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
                
            Spacer()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Displays available vourchers to redeem in columns
                    LazyVGrid(columns: columns, spacing: 20) {
                        // First voucher
                        VStack(spacing: 10) {
                            Text("Guilt-Free Rest")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            Text("Cost: 50 BP")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                            
                            // Purchase voucher button
                            Button(action: {
                                viewModel.purchaseRestVoucher()
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
                        
                        // Dummy data
                        VStack(spacing: 10) {
                            Text("Double BP Boost")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                            Text("Coming Soon")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
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
            Text("You redeemed a Guilt-Free Rest day!")
        }
    }
}

#Preview {
    RedeemItemView()
}
