//
//  TopBarView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// A reusable header component displayed across multiple tabs.
/// Shows the app title, profile picture, and the student's progress.
///
struct TopBarView: View {
    let profile: StudentProfile
    
    @State private var showingProfile = false
    
    var body: some View {
        VStack(spacing: 20) {
            // App's title
            HStack {
                Spacer()
                Text("TaskCatchup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            // Clickable profile picture
            .overlay(
                Button(action: {
                    showingProfile = true
                }) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.blue)
                },
                alignment: .trailing
            )
            
            // Progress section
            VStack(spacing: 10) {
                Text("My Progress")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Current level
                Text("Level \(profile.currentLevel) ⭐️")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                // Level progress bar
                ProgressView(value: Double(profile.lifetimeXP % 100), total: 100)
                    .tint(.orange)
                    .scaleEffect(x: 1.0, y: 1.5, anchor: .center)
                    .padding(.top, 4)
                    .padding(.horizontal, 40)
                
                HStack(spacing: 100) {
                    // Show daily streak
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.red)
                        Text("\(profile.dailyStreak) Days")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    // Show total amount of balance points
                    HStack(spacing: 8) {
                        Image(systemName: "banknote.fill")
                            .foregroundColor(.green)
                        Text("\(profile.balancePoints) BP")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        
        // Opens the Profile View as a sheet
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}
