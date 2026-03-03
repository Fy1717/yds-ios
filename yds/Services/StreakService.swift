//
//  StreakService.swift
//  yds
//

import Foundation
internal import Combine

/// Arka arkaya gün tamamlama streak'i
@MainActor
final class StreakService: ObservableObject {
    static let shared = StreakService()
    
    private enum Keys {
        static let completedDays = "yds_completed_days"
        static let lastCompletedDay = "yds_last_completed_day"
    }
    
    @Published private(set) var streak: Int = 0
    @Published private(set) var completedDays: Set<Int> = []
    
    private init() {
        load()
    }
    
    private func load() {
        if let array = UserDefaults.standard.array(forKey: Keys.completedDays) as? [Int] {
            completedDays = Set(array)
        }
        _ = UserDefaults.standard.object(forKey: Keys.lastCompletedDay) as? Int
        streak = calculateStreak()
    }
    
    private func calculateStreak() -> Int {
        guard !completedDays.isEmpty else { return 0 }
        let sorted = completedDays.sorted(by: >)
        var count = 0
        var expected = sorted.first!
        for day in sorted {
            if day == expected {
                count += 1
                expected -= 1
            } else if day < expected {
                break
            }
        }
        return count
    }
    
    /// Quiz veya Boşluk Doldur tamamlandığında çağrılır
    func recordCompletion(day: Int) {
        guard (1...WordService.totalDays).contains(day) else { return }
        if completedDays.contains(day) { return }
        
        completedDays.insert(day)
        UserDefaults.standard.set(Array(completedDays), forKey: Keys.completedDays)
        UserDefaults.standard.set(day, forKey: Keys.lastCompletedDay)
        streak = calculateStreak()
    }
}

