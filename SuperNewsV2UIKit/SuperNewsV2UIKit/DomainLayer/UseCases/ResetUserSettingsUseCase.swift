//
//  ResetUserSettingsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 05/09/2023.
//

import Foundation

/// This use case resets user settings.
final class ResetUserSettingsUseCase: ResetUserSettingsUseCaseProtocol {
    private let userSettingsRepository: SuperNewsUserSettingsRepository
    
    init(userSettingsRepository: SuperNewsUserSettingsRepository) {
        self.userSettingsRepository = userSettingsRepository
    }
    
    func execute() async -> Result<Void, SuperNewsUserSettingsError> {
        return await userSettingsRepository.resetUserSettings()
    }
}
