//
//  SuperNewsMockCountryLanguageSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

final class SuperNewsMockCountryLanguageSettings: SuperNewsUserSettings {
    private let settingOption: String
    private var savedData: Data?
    
    init(with settingOption: String) {
        print("[SuperNewsMockCountryLanguageSettings] Starting mock CountryLanguageSettings with \(settingOption) option.")
        self.settingOption = settingOption
    }
    
    func saveSelectedUserSetting(setting: CountryLanguageSetting) async -> Result<Void, SuperNewsUserSettingsError> {
        print("[SuperNewsMockCountryLanguageSettings] Saving selected user setting: \(setting.code), name: \(setting.name)")
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode saved source
            let data = try encoder.encode(setting)

            // Write/Set Data
            savedData = data
            
            // Done, notify that saving has succeeded
            return .success(())

        } catch {
            print("ERROR: Unable to encode the selected source to save (\(error))")
            return .failure(.encodeError)
        }
    }
    
    func loadSelectedUserSetting() async -> Result<CountryLanguageSetting, SuperNewsUserSettingsError> {
        print("[SuperNewsMockCountryLanguageSettings] Loading user setting")
        
        if let data = savedData {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode saved source
                let userSetting = try decoder.decode(CountryLanguageSetting.self, from: data)
                
                // Done, notify that loading has succeeded
                return .success(userSetting)
            } catch {
                print("[SuperNewsMockCountryLanguageSettings] ERROR: Unable to decode the user setting (\(error))")
                return .failure(.decodeError)
            }
        }
        
        return .failure(.userSettingsError)
    }
    
    func resetSettings() async -> Result<Void, SuperNewsUserSettingsError> {
        return .failure(.userSettingsError)
    }
}
