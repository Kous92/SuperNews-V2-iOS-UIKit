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
    
    @concurrent func execute(with option: String) async throws -> [CountrySettingViewModel] {
        if option == "country" {
            return parseViewModels(with: try await localFileRepository.loadCountries())
        } else {
            return parseViewModels(with: try await localFileRepository.loadLanguages())
        }
    }
    
    private func parseViewModels(with countries: [CountryDTO]) -> [CountrySettingViewModel] {
        var viewModels = [CountrySettingViewModel]()
        countries.forEach { viewModels.append(CountrySettingViewModel(with: $0)) }
        
        return sortViewModels(with: viewModels)
    }
    
    private func parseViewModels(with languages: [LanguageDTO]) -> [CountrySettingViewModel] {
        var viewModels = [CountrySettingViewModel]()
        languages.forEach { viewModels.append(CountrySettingViewModel(with: $0)) }
        
        return sortViewModels(with: viewModels)
    }
    
    private func sortViewModels(with viewModels: [CountrySettingViewModel]) -> [CountrySettingViewModel] {
        return viewModels.sorted(by: { vm1, vm2 in
            vm1.name < vm2.name
        })
    }
}
