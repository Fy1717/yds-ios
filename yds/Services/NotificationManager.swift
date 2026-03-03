//
//  NotificationManager.swift
//  yds
//

import Foundation
import UserNotifications

#if os(iOS)
/// Günlük kelime hatırlatması
final class NotificationManager {
    static let shared = NotificationManager()
    private let categoryId = "yds_daily_reminder"
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleDailyReminder() {
        cancelAll()
        guard AppSettings.shared.notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "60 Günde YDS"
        content.body = "Bugünkü kelimeler seni bekliyor! 📚"
        content.sound = .default
        content.categoryIdentifier = categoryId
        
        var dateComponents = DateComponents()
        dateComponents.hour = AppSettings.shared.notificationHour
        dateComponents.minute = AppSettings.shared.notificationMinute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: categoryId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
#else
final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    func requestPermission() {}
    func scheduleDailyReminder() {}
    func cancelAll() {}
}
#endif
