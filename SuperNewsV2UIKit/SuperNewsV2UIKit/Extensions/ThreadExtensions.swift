//
//  ThreadExtensions.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 15/10/2025.
//

import Foundation
/// Debug methods to display the current thread (task) in an asynchronous method of the Swift Concurrency context.
/// This is a workaround for the compiler error: Class property 'current' is unavailable from asynchronous contexts; Thread.current cannot be used from async contexts.
/// Check here: https://github.com/swiftlang/swift-corelibs-foundation/issues/5139
extension Thread {
    /// To check with Swift Concurrency the current executed thread. With Swift 6.2 and default isolation on @MainActor, it's necessary to use nonisolated, in order to use this option when debugging outside @MainActor.
    nonisolated public static var currentThread: Thread {
        return Thread.current
    }
    
    /// To check with Swift Concurrency if it's on the main thread.
    public static var isOnMainThread: Bool {
        return Thread.isMainThread
    }
}
