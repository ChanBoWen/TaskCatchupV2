//
//  ProfileView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 3/10/2026.
//

import SwiftUI

/// Displays comprehensive user details, stats, and unlocked features.
///
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    // Grid layout for the stats dashboard
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let profile = viewModel.profile {
                    VStack(spacing: 30) {
                        // Profile picture
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                            
                            // User name
                            Text(profile.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.bottom, 5)
                        
                        // Stats dashboard
                        LazyVGrid(columns: columns, spacing: 15) {
                            // Current level
                            StatCardView(icon: "star.fill", title: "Current Level", value: "\(profile.currentLevel)", color: .orange)
                            
                            // Daily streak
                            StatCardView(icon: "flame.fill", title: "Daily Streak", value: "\(profile.dailyStreak)", color: .red)
                            
                            // Total XP gained
                            StatCardView(icon: "sparkles", title: "Lifetime XP Gained", value: "\(profile.lifetimeXP)", color: .purple)
                            
                            // Total remaining BP
                            StatCardView(icon: "bitcoinsign.circle.fill", title: "Balance Points", value: "\(profile.balancePoints)", color: .yellow)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        // Show active vouchers
                        VStack(alignment: .leading, spacing: 10) {
                            // Header
                            Text("My Inventory")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            // List of every vouchers
                            ForEach(profile.activeVouchers, id: \.self) { voucher in
                                HStack {
                                    Image(systemName: "ticket.fill")
                                        .foregroundColor(.blue)
                                    
                                    Text(voucher.rawValue)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer()
                        
                        // Button to navigate to Settings
                        NavigationLink(destination: SettingsView()) {
                            HStack {
                                Image(systemName: "gearshape")
                                Text("Settings")
                            }
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    ProgressView("Loading Profile...")
                        .padding(.top, 50)
                }
            }
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .offset(y: 30)
                }
                
                // Done button to return
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
