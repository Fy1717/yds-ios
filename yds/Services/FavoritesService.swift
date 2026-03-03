//
//  FavoritesService.swift
//  yds
//

import Foundation
internal import Combine

/// Favori kelime işaretleme
@MainActor
final class FavoritesService: ObservableObject {
    
    static let shared = FavoritesService()
    
    private enum Keys {
        static let favoriteIds = "yds_favorite_ids"
    }
    
    @Published private(set) var favoriteIds: Set<Double> = []
    
    private init() {
        if let array = UserDefaults.standard.array(forKey: Keys.favoriteIds) as? [Double] {
            favoriteIds = Set(array)
        }
    }
    
    func isFavorite(_ wordId: Double) -> Bool {
        favoriteIds.contains(wordId)
    }
    
    func toggle(_ wordId: Double) {
        if favoriteIds.contains(wordId) {
            favoriteIds.remove(wordId)
        } else {
            favoriteIds.insert(wordId)
        }
        UserDefaults.standard.set(Array(favoriteIds), forKey: Keys.favoriteIds)
    }
    
    func filterFavorites(from words: [Word]) -> [Word] {
        words.filter { favoriteIds.contains($0.id) }
    }
}

