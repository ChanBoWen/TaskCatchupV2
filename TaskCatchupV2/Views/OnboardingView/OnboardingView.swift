//
//  OnboardingView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import SwiftUI

/// The first screen a new user sees.
/// Explains the domain rules and creates their Core Data profile.
///
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    // Connects to UserDefaults to remember onboarding is finished
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            
            Spacer()
            
            // Welcome message
            VStack(spacing: 20) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Welcome to\nTaskCatchup")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
            }
            
            // Explain app's features
            VStack(alignment: .leading, spacing: 20) {
                // Extracted feature row view
                FeatureRowView(icon: "calendar", title: "Plan Your Day", desc: "Schedule your events such as classes and shifts for the day.")
                
                FeatureRowView(icon: "checkmark.square.fill", title: "Complete Goals", desc: "Complete your set goals to earn Balance Points (BP) and XP.")
                
                FeatureRowView(icon: "gift.fill", title: "Reward Yourself", desc: "Spend BP on vouchers available to redeem in the shop.")
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Allow user to enter name and submit
            VStack(spacing: 15) {
                TextField("What's your name?", text: $viewModel.userName)
                    .font(.title3)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 30)
                
                Button(action: {
                    // Save the name
                    viewModel.completeOnboarding {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 30)
                }
            }
            .padding(.bottom, 40)
        }
        // Show error if no name is entered
        .alert("Oops!", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a valid name to continue.")
        }
    }
}

#Preview {
    OnboardingView()
}
