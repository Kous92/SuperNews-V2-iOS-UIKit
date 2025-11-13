//
//  SaveUserSettingsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 08/12/2023.
//

import Foundation

/// This use case saves a selected setting from the user
final class SaveUserSettingsUseCase: SaveUserSettingsUseCaseProtocol {
    private let userSettingsRepository: SuperNewsUserSettingsRepository
    
    init(userSettingsRepository: SuperNewsUserSettingsRepository) {
        self.userSettingsRepository = userSettingsRepository
    }
    
    func execute(with countryLanguageSetting: CountryLanguageSettingDTO) async throws -> Bool {
        return try await userSettingsRepository.saveUserSetting(userSetting: countryLanguageSetting)
    }
}
