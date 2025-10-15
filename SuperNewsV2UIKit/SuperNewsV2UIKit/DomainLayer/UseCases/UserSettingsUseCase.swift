//
//  UserSettingsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

/// This use case loads all available options for settings
final class UserSettingsUseCase: UserSettingsUseCaseProtocol {
    
    private let localFileRepository: SuperNewsLocalFileRepository
    
    init(localFileRepository: SuperNewsLocalFileRepository) {
        self.localFileRepository = localFileRepository
    }
    
    /*
    func execute(with option: String) async -> Result<[CountrySettingViewModel], SuperNewsLocalFileError> {
        if option == "country" {
            return handleResultWithCountries(with: await localFileRepository.loadCountries())
        } else {
            return handleResultWithLanguages(with: await localFileRepository.loadLanguages())
        }
    }
     */
    
    @concurrent func execute(with option: String) async throws -> [CountrySettingViewModel] {
        if option == "country" {
            return parseViewModels(with: try await localFileRepository.loadCountries())
        } else {
            return parseViewModels(with: try await localFileRepository.loadLanguages())
        }
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
