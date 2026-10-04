//
//  TaskCatchupWidgets.swift
//  TaskCatchupWidgets
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import WidgetKit
import SwiftUI
import CoreData

// Timeline Entry
struct TaskCatchupEntry: TimelineEntry {
    let date: Date
    let profile: StudentProfile?
    let remainingGoals: [DailyGoal]
}

struct Provider: TimelineProvider {
    // Shared Core Data repository
    let repository: GoalRepository = CoreDataGoalRepository(context: PersistenceController.shared.container.viewContext)
    
    func placeholder(in context: Context) -> TaskCatchupEntry {
        TaskCatchupEntry(date: Date(), profile: nil, remainingGoals: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TaskCatchupEntry) -> ()) {
        let entry = TaskCatchupEntry(date: Date(), profile: nil, remainingGoals: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var profile: StudentProfile? = nil
        var remainingGoals: [DailyGoal] = []
        
        do {
            profile = try repository.fetchProfile()
            remainingGoals = try repository.fetchIncompleteGoals()
        } catch {
            print("Widget failed to load Core Data")
        }
        
        let entry = TaskCatchupEntry(date: Date(), profile: profile, remainingGoals: remainingGoals)
        
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}
    
struct TaskCatchupWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let profile = entry.profile {
                
                // Show the profile stats
                HStack {
                    Text("Level \(profile.currentLevel)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Text("🪙 \(profile.balancePoints)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Divider()
                
                // Show the goals that are not completed
                if entry.remainingGoals.isEmpty {
                    Spacer()
                    
                    Text("All caught up!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                } else {
                    Text("\(entry.remainingGoals.count) Goals Left:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    let maxGoals = family == .systemSmall ? 1 : 3
                    
                    ForEach(entry.remainingGoals.prefix(maxGoals)) { goal in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text(goal.title)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }
                }
            } else {
                Text("Open TaskCatchup to set up your profile!")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        // Widget background
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
    }
}

struct TaskCatchupWidgets: Widget {
    let kind: String = "TaskCatchupWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskCatchupWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Goals")
        .description("Track your Balance Points and remaining daily goals.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemSmall) {
    TaskCatchupWidgets()
} timeline: {
    TaskCatchupEntry(
        date: .now,
        profile: StudentProfile(name: "Alex", balancePoints: 120, lifetimeXP: 250, currentLevel: 3, dailyStreak: 5),
        remainingGoals: [
            DailyGoal(title: "Finish Essay", category: .academic, isRecurring: false, rewardPoints: 20),
            DailyGoal(title: "Drink Water", category: .rest, isRecurring: true, rewardPoints: 5)
        ]
    )
}
