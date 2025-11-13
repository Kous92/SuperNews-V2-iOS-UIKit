//
//  SuperNewsUserDefaultsCountryLanguageSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

final class SuperNewsUserDefaultsCountryLanguageSettings: SuperNewsUserSettings {
    private let settingOption: String
    
    init(with settingOption: String) {
        self.settingOption = settingOption
    }
    
    func saveSelectedUserSetting(setting: CountryLanguageSetting) async throws -> Bool {
        print("[SuperNewsUserDefaultsCountryLanguageSettings] Saving selected user setting: \(setting.code), name: \(setting.name)")
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode saved source
            let data = try encoder.encode(setting)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: settingOption)
            
            // Done, notify that saving has succeeded
            return true

        } catch {
            print("[SuperNewsUserDefaultsCountryLanguageSettings] ERROR: Unable to encode the selected source to save (\(error))")
            throw SuperNewsUserSettingsError.encodeError
        }
    }
    
    func loadSelectedUserSetting() async throws -> CountryLanguageSetting {
        print("[SuperNewsUserDefaultsCountryLanguageSettings] Loading user setting")
        
        if let data = UserDefaults.standard.data(forKey: settingOption) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode saved source
                let userSetting = try decoder.decode(CountryLanguageSetting.self, from: data)
                
                // Done, notify that loading has succeeded
                return userSetting
            } catch {
                print("[SuperNewsUserDefaultsCountryLanguageSettings] ERROR: Unable to decode the user setting (\(error))")
                throw SuperNewsUserSettingsError.decodeError
            }
        }
        
        throw SuperNewsUserSettingsError.userSettingsError
    }
    
    func resetSettings() async throws -> Bool {
        print("[SettingsCoordinator] Resetting user parameters. Thread: \(Thread.currentThread)")
        // Resetting to default parameters
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            let locale = Locale.current
            let languageCode = locale.language.languageCode?.identifier == "fr" ? "fr" : "en"
            let countryCode = locale.language.languageCode?.identifier == "fr" ? "fr" : "us"
            
            // Encode saved source
            let languageData = try encoder.encode(CountryLanguageSetting(name: languageCode.languageName() ?? languageCode, code: languageCode, flagCode: languageCode))
            let countryData = try encoder.encode(CountryLanguageSetting(name: countryCode.countryName() ?? countryCode, code: countryCode, flagCode: countryCode))

            // Write/Set Data
            UserDefaults.standard.set(languageData, forKey: "language")
            UserDefaults.standard.set(countryData, forKey: "country")
            
            print("[SettingsCoordinator] Resetting succeeded.")
            return true
        } catch {
            print("[SettingsCoordinator] Resetting failed.")
            throw SuperNewsUserSettingsError.userSettingsError
        }
    }
}
