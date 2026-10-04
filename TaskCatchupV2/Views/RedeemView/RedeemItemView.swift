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
                        // Extracted grid card view
                        StoreItemCardView(item: item) {
                            viewModel.purchaseVoucher(type: item.type, cost: item.cost, itemName: item.title)
                        }
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
        
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    RedeemItemView()
}
