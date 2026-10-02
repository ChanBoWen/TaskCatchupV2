//
//  MainTabView.swift
//  TaskCatchupV2
//
//  Created by Bo Wen Chan on 2/10/2026.
//

import SwiftUI

/// The root navigation view that connects the screens of the TaskCatchup app.
///
struct MainTabView: View {
    var body: some View {
        TabView {
            // Tab 1
            DailySchedulesView()
                .tabItem {
                    Label("Today Schedule", systemImage: "calendar")
                }
            
            // Tab 2
            DailyGoalsView()
                .tabItem {
                    Label("Daily Goals", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}
