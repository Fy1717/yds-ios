//
//  SharedStorage.swift
//  yds
//

import Foundation

/// Widget ile paylaşılan veri (App Group)
enum SharedStorage {
    static let suiteName = "group.com.fy.yds"
    
    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    enum Keys {
        static let currentDay = "yds_shared_current_day"
        static let todaysWordCount = "yds_shared_todays_word_count"
    }
    
    /// Widget için güncel veriyi güncelle
    static func updateForWidget(currentDay: Int, todaysWordCount: Int) {
        defaults?.set(currentDay, forKey: Keys.currentDay)
        defaults?.set(todaysWordCount, forKey: Keys.todaysWordCount)
    }
    
    static func getCurrentDay() -> Int {
        let d = defaults?.integer(forKey: Keys.currentDay) ?? 1
        return d < 1 ? 1 : min(d, 60)
    }
    
    static func getTodaysWordCount() -> Int {
        max(0, defaults?.integer(forKey: Keys.todaysWordCount) ?? 0)
    }
}
