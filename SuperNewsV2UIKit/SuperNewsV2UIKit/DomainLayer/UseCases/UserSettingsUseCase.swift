//
//  UserSettingsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

final class UserSettingsUseCase: UserSettingsUseCaseProtocol {
    private let userSettingsRepository: SuperNewsUserSettingsRepository
    private let localFileRepository: SuperNewsLocalFileRepository
    
    init(userSettingsRepository: SuperNewsUserSettingsRepository, localFileRepository: SuperNewsLocalFileRepository) {
        self.userSettingsRepository = userSettingsRepository
        self.localFileRepository = localFileRepository
    }
    
    func execute() async -> Result<[CountrySettingViewModel], SuperNewsLocalFileError> {
        return .success([])
    }
    
    func saveSetting(with countryLanguageSetting: CountryLanguageSettingDTO) async -> Result<Void, SuperNewsUserSettingsError> {
        return .failure(.savingError)
    }
    
    func loadSetting() async -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError> {
        return .failure(.loadingError)
    }
}
