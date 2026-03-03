//
//  StatsService.swift
//  yds
//

import Foundation
internal import Combine

/// İstatistik takibi
@MainActor
final class StatsService: ObservableObject {
    
    static let shared = StatsService()
    
    private enum Keys {
        static let quizCompletedCount = "yds_stats_quiz_count"
        static let fillBlankCompletedCount = "yds_stats_fillblank_count"
        static let totalCorrectQuiz = "yds_stats_quiz_correct"
        static let totalCorrectFillBlank = "yds_stats_fillblank_correct"
    }
    
    @Published private(set) var quizCompletedCount: Int = 0
    @Published private(set) var fillBlankCompletedCount: Int = 0
    @Published private(set) var totalCorrectQuiz: Int = 0
    @Published private(set) var totalCorrectFillBlank: Int = 0
    
    var totalActivities: Int { quizCompletedCount + fillBlankCompletedCount }
    
    private init() {
        quizCompletedCount = UserDefaults.standard.integer(forKey: Keys.quizCompletedCount)
        fillBlankCompletedCount = UserDefaults.standard.integer(forKey: Keys.fillBlankCompletedCount)
        totalCorrectQuiz = UserDefaults.standard.integer(forKey: Keys.totalCorrectQuiz)
        totalCorrectFillBlank = UserDefaults.standard.integer(forKey: Keys.totalCorrectFillBlank)
    }
    
    func recordQuiz(correct: Int, total: Int) {
        quizCompletedCount += 1
        totalCorrectQuiz += correct
        UserDefaults.standard.set(quizCompletedCount, forKey: Keys.quizCompletedCount)
        UserDefaults.standard.set(totalCorrectQuiz, forKey: Keys.totalCorrectQuiz)
    }
    
    func recordFillBlank(correct: Int, total: Int) {
        fillBlankCompletedCount += 1
        totalCorrectFillBlank += correct
        UserDefaults.standard.set(fillBlankCompletedCount, forKey: Keys.fillBlankCompletedCount)
        UserDefaults.standard.set(totalCorrectFillBlank, forKey: Keys.totalCorrectFillBlank)
    }
}

