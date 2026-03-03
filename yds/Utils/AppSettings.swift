//
//  AppSettings.swift
//  yds
//

import SwiftUI
internal import Combine

/// Uygulama ayarları (UserDefaults)
final class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private enum Keys {
        static let hapticEnabled = "yds_haptic_enabled"
        static let notificationsEnabled = "yds_notifications_enabled"
        static let notificationHour = "yds_notification_hour"
        static let notificationMinute = "yds_notification_minute"
        static let hasSeenOnboarding = "yds_has_seen_onboarding"
    }
    
    @Published var hapticEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticEnabled, forKey: Keys.hapticEnabled) }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: Keys.notificationsEnabled) }
    }
    
    @Published var notificationHour: Int {
        didSet { UserDefaults.standard.set(notificationHour, forKey: Keys.notificationHour) }
    }
    
    @Published var notificationMinute: Int {
        didSet { UserDefaults.standard.set(notificationMinute, forKey: Keys.notificationMinute) }
    }
    
    @Published var hasSeenOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding) }
    }
    
    var notificationTime: Date {
        get {
            var components = DateComponents()
            components.hour = notificationHour
            components.minute = notificationMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            notificationHour = components.hour ?? 9
            notificationMinute = components.minute ?? 0
        }
    }
    
    private init() {
        self.hapticEnabled = UserDefaults.standard.object(forKey: Keys.hapticEnabled) as? Bool ?? true
        self.notificationsEnabled = UserDefaults.standard.object(forKey: Keys.notificationsEnabled) as? Bool ?? true
        self.notificationHour = UserDefaults.standard.object(forKey: Keys.notificationHour) as? Int ?? 9
        self.notificationMinute = UserDefaults.standard.object(forKey: Keys.notificationMinute) as? Int ?? 0
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
    }
}

