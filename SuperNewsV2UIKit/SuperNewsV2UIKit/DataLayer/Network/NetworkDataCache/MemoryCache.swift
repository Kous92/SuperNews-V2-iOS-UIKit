//
//  MemoryCache.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/09/2023.
//

import Foundation

/** 
 Manages the cache in memory of any data type to prevent downloading same data more than one time. Also, with an `actor` (reference type), it's used to be safe in concurrent environments, meaning with multiple threads (here from `Task` blocks and `async` functions), to prevent data races (unpredictable behaviors, memory corruption, crashes) thanks to a dedicated synchronized access to its isolated data). The data will be accessed with `await` into `async` functions.
    
 Also, this cache manager has an expiration date to make sure when the time interval is expired, to allow the app downloading new data.
 */
actor MemoryCache<T>: NSCacheType {
    // NSCache is used to store data in cache and avoid to download more than one time the same data, also thread safe to avoid data corruption when accessed from multiple threads (tasks).
    let cache: NSCache<NSString, CacheEntry<T>> = .init()
    var keysTracker: KeysTracker<T> = .init()
    let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval) {
        self.expirationInterval = expirationInterval
    }
}
