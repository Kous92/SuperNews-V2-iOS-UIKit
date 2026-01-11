//
//  SuperNewsLocalSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

protocol SuperNewsLocalSettings: Sendable {
    // func saveSelectedMediaSource(source: SavedSource) async -> Result<Void, SuperNewsLocalSettingsError>
    // func loadSelectedMediaSource() async -> Result<SavedSource, SuperNewsLocalSettingsError>
    @discardableResult func saveSelectedMediaSource(source: SavedSource) async throws -> Bool
    func loadSelectedMediaSource() async throws -> SavedSource
}
