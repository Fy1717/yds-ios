//
//  Word.swift
//  yds
//
//  Created by Furkan Yıldız on 18.02.2026.
//

import Foundation

/// YDS hazırlık kelimesi - Firebase uyumlu format
/// day: Hangi güne ait (1-60)
/// synonyms: Virgülle ayrılmış eş anlamlı kelimeler
struct Word: Identifiable, Codable, Equatable {
    let id: Double
    let day: Int
    let english: String
    let turkish: String
    let synonyms: String?
    let example: String
    let exampleTurkish: String?
    let addedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, day, english, turkish, synonyms, example, exampleTurkish, addedDate
    }
    
    init(
        id: Double,
        day: Int,
        english: String,
        turkish: String,
        synonyms: String? = nil,
        example: String,
        exampleTurkish: String? = nil,
        addedDate: String? = nil
    ) {
        self.id = id
        self.day = day
        self.english = english
        self.turkish = turkish
        self.synonyms = synonyms
        self.example = example
        self.exampleTurkish = exampleTurkish
        self.addedDate = addedDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Double.self, forKey: .id)
        day = try container.decodeIfPresent(Int.self, forKey: .day) ?? 1
        english = try container.decode(String.self, forKey: .english)
        turkish = try container.decode(String.self, forKey: .turkish)
        synonyms = try container.decodeIfPresent(String.self, forKey: .synonyms)
        example = try container.decodeIfPresent(String.self, forKey: .example) ?? ""
        exampleTurkish = try container.decodeIfPresent(String.self, forKey: .exampleTurkish)
        addedDate = try container.decodeIfPresent(String.self, forKey: .addedDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(day, forKey: .day)
        try container.encode(english, forKey: .english)
        try container.encode(turkish, forKey: .turkish)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
        try container.encode(example, forKey: .example)
        try container.encodeIfPresent(exampleTurkish, forKey: .exampleTurkish)
        try container.encodeIfPresent(addedDate, forKey: .addedDate)
    }
    
    /// Eş anlamlı kelimeleri liste olarak döndürür
    var synonymsList: [String] {
        guard let s = synonyms, !s.isEmpty else { return [] }
        return s.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
