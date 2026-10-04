//
//  NotificationView.swift
//  TaskCatchupNotification
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import SwiftUI
import CoreData

struct NotificationView: View {
    @State private var profile: StudentProfile?

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                
                Text("It's Time to Plan Your Day!")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            if let profile = profile {
                Text("Hey \(profile.name), don't break your streak! Set your goals and schedule for today to stay on top of your workload.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Current Streak")
                            .font(.caption)
                        
                        HStack {
                            Image(systemName: "flame.fill").foregroundColor(.red)
                            Text("\(profile.dailyStreak) Days")
                                .fontWeight(.bold)
                        }
                    }
                    
                    VStack {
                        Text("Current Level")
                            .font(.caption)
                        Text("Level \(profile.currentLevel) ⭐️")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            } else {
                Text("Loading your stats...")
                    .font(.caption)
            }
        }
        .padding()
        .onAppear {
            loadProfile()
        }
    }
    
    // Reads directly from database
    private func loadProfile() {
        let repo = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)
        
        if let fetchedProfile = try? repo.fetchProfile() {
            self.profile = fetchedProfile
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    NotificationView()
        .frame(height: 180)
}
