//
//  ydsApp.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import SwiftUI

@main
struct ydsApp: App {
    init() {
        if AppSettings.shared.notificationsEnabled {
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleDailyReminder()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
