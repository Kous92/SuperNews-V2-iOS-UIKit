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
    
    func saveUserSetting(userSetting: CountryLanguageSettingDTO) async -> Result<Void, SuperNewsUserSettingsError> {
        guard let result = await settingsService?.saveSelectedUserSetting(setting: dtoToCountryLanguageSetting(with: userSetting)) else {
            return .failure(.userSettingsError)
        }
        
        return result
    }
    
    func loadUserSetting() async -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError> {
        guard let result = await settingsService?.loadSelectedUserSetting() else {
            return .failure(.userSettingsError)
        }
        
        return handleSavedCountryLanguageSetting(with: result)
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
