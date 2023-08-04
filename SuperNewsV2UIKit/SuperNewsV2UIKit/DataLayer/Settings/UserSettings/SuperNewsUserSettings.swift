//
//  SuperNewsUserSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/08/2023.
//

import Foundation

protocol SuperNewsUserSettings {
    func saveSelectedUserSetting(setting: CountryLanguageSetting) async -> Result<Void, SuperNewsUserSettingsError>
    func loadSelectedUserSetting() async -> Result<CountryLanguageSetting, SuperNewsUserSettingsError>
    func resetSettings() async -> Result<Void, SuperNewsUserSettingsError>
}
