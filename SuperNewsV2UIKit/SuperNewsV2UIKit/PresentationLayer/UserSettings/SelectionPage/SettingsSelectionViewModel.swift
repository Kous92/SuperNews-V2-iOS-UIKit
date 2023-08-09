//
//  SettingsSelectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation
import Combine

final class SettingsSelectionViewModel {
    weak var coordinator: SettingsSelectionViewControllerDelegate?
    
    private let settingSection: SettingsSection
    private let useCase: UserSettingsUseCaseProtocol
    private var cellViewModels = [CountrySettingViewModel]()
    
    // MARK: - Binding
    private var settingOptionResult = PassthroughSubject<String, Never>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var settingOption: AnyPublisher<String, Never> {
        return settingOptionResult.eraseToAnyPublisher()
    }
    
    init(settingSection: SettingsSection, useCase: UserSettingsUseCaseProtocol) {
        self.settingSection = settingSection
        self.useCase = useCase
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func loadCountryLanguageOptions() {
        print(settingSection)
        settingOptionResult.send(settingSection.detail)
        settingSection.description == "country" ? loadCountries() : loadLanguages()
    }
    
    private func loadCountries() {
        Task {
            print("[SettingsSelectionViewModel] Loading countries")
            let result = await useCase.execute(with: settingSection.description)
            
            switch result {
                case .success(let viewModels):
                    self.cellViewModels = viewModels
                    self.updateResult.send(true)
                case .failure(let error):
                    print("[SettingsSelectionViewModel] Loading failed.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    private func loadLanguages() {
        Task {
            print("[SettingsSelectionViewModel] Loading languages")
            let result = await useCase.execute(with: settingSection.description)
            
            switch result {
                case .success(let viewModels):
                    self.cellViewModels = viewModels
                    self.updateResult.send(true)
                case .failure(let error):
                    print("[SettingsSelectionViewModel] Loading failed.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
}

extension SettingsSelectionViewModel {
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return cellViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CountrySettingViewModel? {
        // A TableView must have at least one section and one element on CellViewModels list, crash othervise
        let cellCount = cellViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return cellViewModels[indexPath.row]
    }
    
    // Navigation part
    func backToPreviousScreen() {
        coordinator?.backToPreviousScreen()
    }
}
