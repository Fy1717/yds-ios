//
//  SharedStorage.swift
//  ydsWidget
//
//  Widget için - App Group üzerinden ana uygulama ile veri paylaşır.
//  Ana uygulama (yds) aynı suite ile yazar.
//

import Foundation

enum SharedStorage {
    static let suiteName = "group.com.fy.yds"
    
    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    enum Keys {
        static let currentDay = "yds_shared_current_day"
        static let todaysWordCount = "yds_shared_todays_word_count"
    }
    
    static func getCurrentDay() -> Int {
        let d = defaults?.integer(forKey: Keys.currentDay) ?? 1
        return d < 1 ? 1 : min(d, 60)
    }
    
    static func getTodaysWordCount() -> Int {
        max(0, defaults?.integer(forKey: Keys.todaysWordCount) ?? 0)
    }
}
