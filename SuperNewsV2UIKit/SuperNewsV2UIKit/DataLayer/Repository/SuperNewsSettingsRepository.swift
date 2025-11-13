//
//  SuperNewsSettingsRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

/// The link between app layer (domain) and data layer of SuperNews app Clean Architecture. This class follows the Repository design pattern to provide an abstraction of data part, as interface to retrieve data. This repository handles all settings loading and saving part.
protocol SuperNewsSettingsRepository: AnyObject, Sendable {
    func saveUserSetting(userSetting: CountryLanguageSettingDTO) async throws -> Bool
    func loadUserSetting() async throws -> CountryLanguageSettingDTO
    func resetUserSettings() async throws -> Bool
}
