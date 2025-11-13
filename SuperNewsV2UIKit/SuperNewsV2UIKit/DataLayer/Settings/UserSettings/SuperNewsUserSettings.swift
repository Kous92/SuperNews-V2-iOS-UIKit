//
//  SuperNewsUserSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/08/2023.
//

import Foundation

protocol SuperNewsUserSettings: Sendable {
    func saveSelectedUserSetting(setting: CountryLanguageSetting) async throws -> Bool
    func loadSelectedUserSetting() async throws -> CountryLanguageSetting
    func resetSettings() async throws -> Bool
}
