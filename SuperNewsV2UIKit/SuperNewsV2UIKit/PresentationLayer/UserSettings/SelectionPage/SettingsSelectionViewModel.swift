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
    private let userSettingsUseCase: UserSettingsUseCaseProtocol
    private let loadUserSettingsUseCase: LoadUserSettingsUseCaseProtocol
    private let saveUserSettingsUseCase: SaveUserSettingsUseCaseProtocol
    
    private var cellViewModels = [CountrySettingViewModel]()
    private var filteredCellViewModels = [CountrySettingViewModel]()
    private var actualSelectedIndex = 0
    private var actualFilteredSelectedIndex = 0
    
    // User setting
    private var savedCountryLanguageSetting: CountryLanguageSettingDTO
    
    // MARK: - Binding
    @Published var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var settingOptionResult = PassthroughSubject<String, Never>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var settingOptionResultPublisher: AnyPublisher<String, Never> {
        return settingOptionResult.eraseToAnyPublisher()
    }
    
    init(settingSection: SettingsSection, userSettingsUseCase: UserSettingsUseCaseProtocol, loadUserSettingsUseCase: LoadUserSettingsUseCaseProtocol, saveUserSettingsUseCase: SaveUserSettingsUseCaseProtocol) {
        self.settingSection = settingSection
        self.userSettingsUseCase = userSettingsUseCase
        self.loadUserSettingsUseCase = loadUserSettingsUseCase
        self.saveUserSettingsUseCase = saveUserSettingsUseCase
        
        let locale = Locale.current
        let languageCode = locale.languageCode == "fr" ? "fr" : "en"
        let countryCode = locale.languageCode == "fr" ? "fr" : "us"
        
        if settingSection.description == "country" {
            savedCountryLanguageSetting = CountryLanguageSettingDTO(name: countryCode.countryName() ?? countryCode, code: countryCode, flagCode: countryCode)
        } else {
            savedCountryLanguageSetting = CountryLanguageSettingDTO(name: languageCode.languageName() ?? languageCode, code: languageCode, flagCode: languageCode)
        }
        
        setBindings()
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.filterViewModels()
            }.store(in: &subscriptions)
    }
    
    private func filterViewModels() {
        Task {
            guard !searchQuery.isEmpty else {
                filteredCellViewModels = cellViewModels
                await updateViewModelsWithSavedSetting()
                self.updateResult.send(true)
                return
            }
            
            print("[SourceSelectionViewModel] Filtering settings list with: \(searchQuery)")
            filteredCellViewModels.removeAll()
            filteredCellViewModels = cellViewModels.filter { viewModel in
                print("Filter: \(viewModel.name.lowercased()), searchQuery: \(searchQuery.lowercased())")
                
                // Not working with vm.name.lowercased().replacingOccurrences(of: "\\", with: "") to find sources with "'" due to backslash encoding on retrieved data.
                let name = String(NSString(string: viewModel.name.lowercased()))
                
                // Also, with UI, if we search a name with "'", it will use an other kind of apostrophe "’" leading to search confusions.
                let search = searchQuery.lowercased().replacingOccurrences(of: "’", with: "'")
                
                return name.contains(search)
            }
            
            if filteredCellViewModels.count > 0 {
                await updateFilteredViewModelsWithSavedSetting()
                self.updateResult.send(true)
            } else {
                updateResult.send(false)
            }
        }
    }
    
    func loadCountryLanguageOptions() {
        print(settingSection)
        settingOptionResult.send(settingSection.detail)
        settingSection.description == "country" ? loadCountries() : loadLanguages()
    }
    
    private func loadCountries() {
        Task {
            print("[SettingsSelectionViewModel] Loading countries")
            await handleResult(with: await userSettingsUseCase.execute(with: settingSection.description))
        }
    }
    
    private func loadLanguages() {
        Task {
            print("[SettingsSelectionViewModel] Loading languages")
            await handleResult(with: await userSettingsUseCase.execute(with: settingSection.description))
        }
    }
    
    private func handleResult(with result: Result<[CountrySettingViewModel], SuperNewsLocalFileError>) async {
        switch result {
        case .success(let viewModels):
            self.cellViewModels = viewModels
            await sortViewModels()
            self.filteredCellViewModels = viewModels
            await loadSetting()
        case .failure(let error):
            print("[SettingsSelectionViewModel] Loading failed.")
            print("[SettingsSelectionViewModel] ERROR: \(error.rawValue)")
            await self.sendErrorMessage(with: error.rawValue)
        }
    }
    
    private func loadSetting() async {
        let result = await loadUserSettingsUseCase.execute()
        
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
        if let index = cellViewModels.firstIndex(where: { $0.code == savedCountryLanguageSetting.code }) {
            cellViewModels[index].setIsSaved(saved: true)
            actualSelectedIndex = index
            actualFilteredSelectedIndex = actualSelectedIndex
        }
    }
    
    private func updateFilteredViewModelsWithSavedSetting() async {
        if let index = filteredCellViewModels.firstIndex(where: { $0.code == savedCountryLanguageSetting.code }) {
            filteredCellViewModels[index].setIsSaved(saved: true)
            actualFilteredSelectedIndex = index
        }
    }
    
    private func unsetSavedViewModel() async {
        if let index = cellViewModels.firstIndex(where: { $0.code == savedCountryLanguageSetting.code }) {
            cellViewModels[index].setIsSaved(saved: false)
        }
        
        // For filtered case
        if filteredCellViewModels.count < cellViewModels.count, let index = filteredCellViewModels.firstIndex(where: { $0.code == savedCountryLanguageSetting.code }) {
            filteredCellViewModels[index].setIsSaved(saved: false)
        }
    }
    
    /// Sort settings view models by alphabetical order
    private func sortViewModels() async {
        cellViewModels = cellViewModels.sorted(by: { vm1, vm2 in
            vm1.name < vm2.name
        })
    }
    
    func saveSelectedSetting(at indexPath: IndexPath) {
        guard let cellViewModel = getCellViewModel(at: indexPath) else {
            print("[SettingsSelectionViewModel] ERROR when selecting the cell")
            return
        }
        
        let isNotFiltered = cellViewModels.count == filteredCellViewModels.count
        
        if isNotFiltered {
            actualSelectedIndex = indexPath.row
        } else {
            actualFilteredSelectedIndex = indexPath.row
        }
        
        let savedSelectedSetting = CountryLanguageSettingDTO(name: cellViewModel.name, code: cellViewModel.code, flagCode: cellViewModel.flagCode)
        print("[SettingsSelectionViewModel] Selected \(settingSection.description) to save: \(savedSelectedSetting.name), code: \(savedSelectedSetting.code), flagCode: \(savedSelectedSetting.flagCode)")
        
        Task {
            await unsetSavedViewModel()
            let result = await saveUserSettingsUseCase.execute(with: savedSelectedSetting)
            
            switch result {
            case .success():
                print("[SettingsSelectionViewModel] Saving succeeded")
                savedCountryLanguageSetting = savedSelectedSetting
                await updateViewModelsWithSavedSetting()
                await updateFilteredViewModelsWithSavedSetting()
                self.updateResult.send(true)
            case .failure(let error):
                print("[SettingsSelectionViewModel] Saving failed. ERROR: \(error.rawValue)")
                await sendErrorMessage(with: String(localized: String.LocalizationValue(error.rawValue)))
            }
        }
    }
}

extension SettingsSelectionViewModel {
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return cellViewModels.count == filteredCellViewModels.count ? cellViewModels.count : filteredCellViewModels.count
    }
    
    func getActualSelectedIndex() -> Int {
        return cellViewModels.count == filteredCellViewModels.count ? actualSelectedIndex : actualFilteredSelectedIndex
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CountrySettingViewModel? {
        let isNotFiltered = cellViewModels.count == filteredCellViewModels.count
        
        // A TableView must have at least one section and one element on CellViewModels list, crash othervise
        let cellCount = isNotFiltered ? cellViewModels.count : filteredCellViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return isNotFiltered ? cellViewModels[indexPath.row] : filteredCellViewModels[indexPath.row]
    }
    
    // Navigation part
    @MainActor func backToPreviousScreen() {
        coordinator?.backToPreviousScreen()
    }
}
