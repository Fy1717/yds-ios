//
//  WordService.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import Foundation
internal import Combine

/// 60 günde YDS hazırlık - günlük kelime servisi
@MainActor
final class WordService: ObservableObject {
    static let totalDays = 60
    private static let currentDayKey = "yds_current_day"
    private static let apiURL = "https://yds-api-yhmx.onrender.com/api/words"
    
    @Published var allWords: [Word] = []
    @Published var currentDay: Int
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        self.currentDay = UserDefaults.standard.integer(forKey: Self.currentDayKey)
        if currentDay < 1 { currentDay = 1 }
        if currentDay > Self.totalDays { currentDay = Self.totalDays }
        loadWords()
    }
    
    /// Bugünkü günün kelimeleri
    var todaysWords: [Word] {
        allWords.filter { $0.day == currentDay }
    }
    
    /// Belirli bir günün kelimeleri
    func words(for day: Int) -> [Word] {
        allWords.filter { $0.day == day }
    }
    
    /// Tüm kelimeler (geçmiş günler dahil - tekrar için)
    var wordsUpToCurrentDay: [Word] {
        allWords.filter { $0.day <= currentDay }
    }
    
    func shuffledWords() -> [Word] {
        todaysWords.shuffled()
    }
    
    func loadWords() {
        isLoading = true
        errorMessage = nil
        Task {
            await loadWordsAsync()
        }
    }
    
    private func loadWordsAsync() async {
        if let words = await fetchFromAPI() {
            allWords = words
            isLoading = false
            SharedStorage.updateForWidget(currentDay: currentDay, todaysWordCount: todaysWords.count)
            return
        }
        loadFromBundle()
    }
    
    private func fetchFromAPI() async -> [Word]? {
        guard let url = URL(string: Self.apiURL) else { return nil }
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 20
        let session = URLSession(configuration: config)
        do {
            let (data, response) = try await session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            let words = try JSONDecoder().decode([Word].self, from: data)
            return words.isEmpty ? nil : words
        } catch {
            return nil
        }
    }
    
    private func loadFromBundle() {
        guard let url = Bundle.main.url(forResource: "yds_words", withExtension: "json", subdirectory: "assets")
            ?? Bundle.main.url(forResource: "yds_words", withExtension: "json")
            ?? Bundle.main.url(forResource: "sample_words", withExtension: "json", subdirectory: "assets")
            ?? Bundle.main.url(forResource: "sample_words", withExtension: "json") else {
            errorMessage = "Kelime dosyası bulunamadı."
            isLoading = false
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let words = try JSONDecoder().decode([Word].self, from: data)
            allWords = words
            SharedStorage.updateForWidget(currentDay: currentDay, todaysWordCount: todaysWords.count)
        } catch {
            errorMessage = "Kelimeler yüklenemedi: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func advanceToNextDay() {
        guard currentDay < Self.totalDays else { return }
        currentDay += 1
        UserDefaults.standard.set(currentDay, forKey: Self.currentDayKey)
        SharedStorage.updateForWidget(currentDay: currentDay, todaysWordCount: todaysWords.count)
    }
    
    func goToPreviousDay() {
        guard currentDay > 1 else { return }
        currentDay -= 1
        UserDefaults.standard.set(currentDay, forKey: Self.currentDayKey)
        SharedStorage.updateForWidget(currentDay: currentDay, todaysWordCount: todaysWords.count)
    }
    
    func setDay(_ day: Int) {
        let clamped = min(max(day, 1), Self.totalDays)
        currentDay = clamped
        UserDefaults.standard.set(currentDay, forKey: Self.currentDayKey)
        SharedStorage.updateForWidget(currentDay: currentDay, todaysWordCount: todaysWords.count)
    }
    
    /// Genel ilerleme (0.0 - 1.0)
    var progress: Double {
        Double(currentDay) / Double(Self.totalDays)
    }
}
