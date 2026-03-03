//
//  ContentView.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = AppSettings.shared.hasSeenOnboarding
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView(isCompleted: $hasCompletedOnboarding)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
