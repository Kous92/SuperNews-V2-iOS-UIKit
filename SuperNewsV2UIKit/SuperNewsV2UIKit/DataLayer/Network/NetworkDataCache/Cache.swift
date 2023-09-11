//
//  Cache.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 11/09/2023.
//

import Foundation

// Concrete object conforming to this protocol must to be an actor
protocol Cache: Actor {
    associatedtype T // Generic type
    var expirationInterval: TimeInterval { get }
    
    func setValue(_ value: T?, key: String)
    func value(key: String) -> T?
    func removeValue(key: String)
    func removeAllValues()
}

protocol NSCacheType: Cache {
    var cache: NSCache<NSString, CacheEntry<T>> { get }
    var keysTracker: KeysTracker<T> { get }
}

extension NSCacheType {
    /// Removes all cached content releated to the key
    func removeValue(key: String) {
        keysTracker.keys.remove(key)
        cache.removeObject(forKey: key as NSString)
    }
    
    /// Clears completely the cache (all keys)
    func removeAllValues() {
        keysTracker.keys.removeAll()
        cache.removeAllObjects()
    }
    
    func setValue(_ value: T?, key: String) {
        if let value = value {
            let expiredTimestamp = Date().addingTimeInterval(expirationInterval)
            let cacheEntry = CacheEntry(key: key, value: value, expiredTimestamp: expiredTimestamp)
            insert(cacheEntry)
        } else {
            removeValue(key: key)
        }
    }
    
    func value(key: String) -> T? {
        entry(key: key)?.value
    }
    
    func entry(key: String) -> CacheEntry<T>? {
        guard let entry = cache.object(forKey: key as NSString) else {
            print("[\(Self.Type.self)] No content found for key: \(key).")
            return nil
        }
        
        // Checking cache expiration. The cached data have to be removed when expiration date is reached.
        guard !entry.isCacheExpired(after: Date()) else {
            print("[\(Self.Type.self)] Cache expired for key: \(key), removing cached content.")
            removeValue(key: key)
            return nil
        }
        
        return entry
    }
    
    func insert(_ entry: CacheEntry<T>) {
        keysTracker.keys.insert(entry.key)
        cache.setObject(entry, forKey: entry.key as NSString)
        print("[\(Self.Type.self)] Cache set for key: \(entry.key).")
    }
}
