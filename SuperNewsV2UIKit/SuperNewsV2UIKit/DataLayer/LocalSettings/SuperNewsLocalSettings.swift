//
//  SuperNewsLocalSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

protocol SuperNewsLocalSettings {
    func saveSelectedMediaSource(source: SavedSource) async -> Result<Void, SuperNewsLocalSettingsError>
    func loadSelectedMediaSource() async -> Result<SavedSource, SuperNewsLocalSettingsError>
}
