//
//  LoadUserSettingsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 08/12/2023.
//

import Foundation

final class LoadUserSettingsUseCase: LoadUserSettingsUseCaseProtocol {
    private let userSettingsRepository: SuperNewsSettingsRepository
    
    init(userSettingsRepository: SuperNewsSettingsRepository) {
        self.userSettingsRepository = userSettingsRepository
    }
    
    func execute() async throws -> CountryLanguageSettingDTO {
        return try await userSettingsRepository.loadUserSetting()
    }
}
