//
//  SuperNewsUserSettingsRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

final class SuperNewsUserSettingsRepository: SuperNewsSettingsRepository {
    private let settingsService: SuperNewsUserSettings?
    
    init(settingsService: SuperNewsUserSettings?) {
        self.settingsService = settingsService
    }
    
    func saveUserSetting(userSetting: CountryLanguageSettingDTO) async throws -> Bool {
        guard let result = try await settingsService?.saveSelectedUserSetting(setting: dtoToCountryLanguageSetting(with: userSetting)) else {
            throw SuperNewsUserSettingsError.userSettingsError
        }
        
        return result
    }
    
    func loadUserSetting() async throws -> CountryLanguageSettingDTO {
        guard let result = try await settingsService?.loadSelectedUserSetting() else {
            throw SuperNewsUserSettingsError.userSettingsError
        }
        
        return countryLanguageSettingToDTO(with: result)
    }
    
    func resetUserSettings() async throws -> Bool {
        print("Reset user settings repository. Thread: \(Thread.currentThread)")
        guard let result = try await settingsService?.resetSettings() else {
            throw SuperNewsUserSettingsError.userSettingsError
        }
        
        return result
    }
    
    private func handleSavedCountryLanguageSetting(with result: Result<CountryLanguageSetting, SuperNewsUserSettingsError>) -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError> {
        switch result {
            case .success(let userSetting):
                return .success(countryLanguageSettingToDTO(with: userSetting))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    /// Converts Data Transfer Object to CountryLanguageSetting for Data Layer
    private func dtoToCountryLanguageSetting(with dto: CountryLanguageSettingDTO) -> CountryLanguageSetting {
        return dto.getCountryLanguageSetting()
    }
    
    /// Converts SavedSource data objects to Source Data Transfer Object for Domain Layer
    private func countryLanguageSettingToDTO(with countryLanguageSetting: CountryLanguageSetting) -> CountryLanguageSettingDTO {
        return countryLanguageSetting.getDTO()
    }
}
