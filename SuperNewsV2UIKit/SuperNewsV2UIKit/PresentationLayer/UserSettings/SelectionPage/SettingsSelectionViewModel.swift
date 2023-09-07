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
    private var actualSelectedIndex = 0
    
    // User setting
    private var savedCountryLanguageSetting: CountryLanguageSettingDTO
    
    // MARK: - Binding
    private var settingOptionResult = PassthroughSubject<String, Never>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var settingOptionResultPublisher: AnyPublisher<String, Never> {
        return settingOptionResult.eraseToAnyPublisher()
    }
    
    init(settingSection: SettingsSection, useCase: UserSettingsUseCaseProtocol) {
        self.settingSection = settingSection
        self.useCase = useCase
        
        if settingSection.description == "country" {
            savedCountryLanguageSetting = CountryLanguageSettingDTO(name: "France", code: "fr", flagCode: "fr")
        } else {
            savedCountryLanguageSetting = CountryLanguageSettingDTO(name: "Français", code: "fr", flagCode: "fr")
        }
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
                    await loadSetting()
                case .failure(let error):
                    print("[SettingsSelectionViewModel] Loading failed.")
                    print("[SettingsSelectionViewModel] ERROR: \(error.rawValue)")
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
                    await loadSetting()
                case .failure(let error):
                    print("[SettingsSelectionViewModel] Loading failed.")
                    print("[SettingsSelectionViewModel] ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    private func loadSetting() async {
        let result = await useCase.loadUserCountryLanguageSetting()
        
        switch result {
            case .success(let userSetting):
                print("[SettingsSelectionViewModel] Loading succeeded for saved user country setting: \(userSetting.name), code: \(userSetting.code)")
                self.savedCountryLanguageSetting = userSetting
            case .failure(let error):
                print("[SettingsSelectionViewModel] Loading failed, the default user country setting will be used: \(savedCountryLanguageSetting.name), code: \(savedCountryLanguageSetting.code), flagCode: \(savedCountryLanguageSetting.flagCode)")
                print("[SettingsSelectionViewModel] ERROR: \(error.rawValue)")
        }
        
        await updateViewModelsWithSavedSetting()
        self.updateResult.send(true)
    }
    
    private func updateViewModelsWithSavedSetting() async {
        if let index = cellViewModels.firstIndex(where: { $0.name == savedCountryLanguageSetting.name }) {
            cellViewModels[index].setIsSaved(saved: true)
            actualSelectedIndex = index
        }
    }
    
    func saveSelectedSetting(at indexPath: IndexPath) {
        guard let cellViewModel = getCellViewModel(at: indexPath) else {
            print("[SettingsSelectionViewModel] ERROR when selecting the cell")
            return
        }
        
        actualSelectedIndex = indexPath.row
        let savedSelectedSetting = CountryLanguageSettingDTO(name: cellViewModel.name, code: cellViewModel.code, flagCode: cellViewModel.flagCode)
        print("[SettingsSelectionViewModel] Selected \(settingSection.description) to save: \(savedSelectedSetting.name), code: \(savedSelectedSetting.code), flagCode: \(savedSelectedSetting.flagCode)")
        
        Task {
            let result = await useCase.saveSetting(with: savedSelectedSetting)
            
            switch result {
                case .success():
                    print("[SettingsSelectionViewModel] Saving succeeded")
                    savedCountryLanguageSetting = savedSelectedSetting
                case .failure(let error):
                    print("[SettingsSelectionViewModel] Saving failed. ERROR: \(error.rawValue)")
            }
        }
    }
}

extension SettingsSelectionViewModel {
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return cellViewModels.count
    }
    
    func getActualSelectedIndex() -> Int {
        return actualSelectedIndex
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
