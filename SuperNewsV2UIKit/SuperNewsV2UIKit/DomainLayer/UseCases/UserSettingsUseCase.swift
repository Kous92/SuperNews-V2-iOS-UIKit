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
    
    func execute(with option: String) async -> Result<[CountrySettingViewModel], SuperNewsLocalFileError> {
        if option == "country" {
            return handleResultWithCountries(with: await localFileRepository.loadCountries())
        } else {
            return handleResultWithLanguages(with: await localFileRepository.loadLanguages())
        }
    }
    
    func saveSetting(with countryLanguageSetting: CountryLanguageSettingDTO) async -> Result<Void, SuperNewsUserSettingsError> {
        return await userSettingsRepository.saveUserSetting(userSetting: countryLanguageSetting)
    }
    
    func loadUserCountryLanguageSetting() async -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError> {
        return await userSettingsRepository.loadUserSetting()
    }
    
    private func handleResultWithCountries(with result: Result<[CountryDTO], SuperNewsLocalFileError>) -> Result<[CountrySettingViewModel], SuperNewsLocalFileError> {
        switch result {
            case .success(let countries):
                return .success(parseViewModels(with: countries))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func handleResultWithLanguages(with result: Result<[LanguageDTO], SuperNewsLocalFileError>) -> Result<[CountrySettingViewModel], SuperNewsLocalFileError> {
        switch result {
            case .success(let languages):
                return .success(parseViewModels(with: languages))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func parseViewModels(with countries: [CountryDTO]) -> [CountrySettingViewModel] {
        var viewModels = [CountrySettingViewModel]()
        countries.forEach { viewModels.append(CountrySettingViewModel(with: $0)) }
        
        return viewModels
    }
    
    private func parseViewModels(with languages: [LanguageDTO]) -> [CountrySettingViewModel] {
        var viewModels = [CountrySettingViewModel]()
        languages.forEach { viewModels.append(CountrySettingViewModel(with: $0)) }
        
        return viewModels
    }
}