//
//  CacheEntry.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/09/2023.
//

import Foundation

/// This object allows to contain any type of content to save/load from cache with an expiration time.
final class CacheEntry<T> {

    let key: String
    let value: T
    let expiredTimestamp: Date
    
    init(key: String, value: T, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }
    
    /// Check if the cached data is expired
    func isCacheExpired(after date: Date) -> Bool {
        date > expiredTimestamp
    }
}

// CacheEntry will support codable type
extension CacheEntry: Codable where T: Codable {}
