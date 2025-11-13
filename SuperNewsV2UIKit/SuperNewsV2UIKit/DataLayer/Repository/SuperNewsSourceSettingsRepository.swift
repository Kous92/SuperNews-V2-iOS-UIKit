//
//  SuperNewsSourceSettingsRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

/// The link between app layer (domain) and data layer of SuperNews app Clean Architecture. This class follows the Repository design pattern to provide an abstraction of data part, as interface to retrieve data. This repository handles all settings loading and saving part.
protocol SuperNewsSourceSettingsRepository: AnyObject, Sendable {
    func saveSelectedMediaSource(source: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError>
    func loadSelectedMediaSource() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError>
}
