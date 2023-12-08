//
//  SettingsSelectionModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation
import UIKit

final class SettingsSelectionModuleBuilder: ModuleBuilder {
    private var testMode = false
    private let settingSection: SettingsSection
    
    init(settingSection: SettingsSection) {
        self.settingSection = settingSection
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let settingsSelectionViewController = SettingsSelectionViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let userSettingRepository = getUserSettingRepository(testMode: testMode)
        let localFileRepository = getLocalFileRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let userSettingsUseCase = UserSettingsUseCase(localFileRepository: localFileRepository)
        let loadUserSettingsUseCase = LoadUserSettingsUseCase(userSettingsRepository: userSettingRepository)
        let saveUserSettingsUseCase = SaveUserSettingsUseCase(userSettingsRepository: userSettingRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let settingsSelectionViewModel = SettingsSelectionViewModel(settingSection: settingSection, userSettingsUseCase: userSettingsUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase, saveUserSettingsUseCase: saveUserSettingsUseCase)
        
        // 4) Injecting coordinator for presentation layer
        settingsSelectionViewModel.coordinator = coordinator as? SettingsSelectionViewControllerDelegate
        
        // 5) Injecting view model to the view
        settingsSelectionViewController.viewModel = settingsSelectionViewModel
        
        return settingsSelectionViewController
    }
    
    private func getUserSettingRepository(testMode: Bool) -> SuperNewsUserSettingsRepository {
        return SuperNewsUserSettingsRepository(settingsService: getUserSettingsService(testMode: testMode))
    }
    
    private func getLocalFileRepository(testMode: Bool) -> SuperNewsLocalFileRepository {
        return SuperNewsJSONFileRepository(localFileService: getLocalFileService(testMode: testMode))
    }
    
    private func getUserSettingsService(testMode: Bool) -> SuperNewsUserSettings {
        return testMode ? SuperNewsUserDefaultsCountryLanguageSettings(with: settingSection.description) : SuperNewsUserDefaultsCountryLanguageSettings(with: settingSection.description)
    }
    
    private func getLocalFileService(testMode: Bool) -> SuperNewsLocalDataFileService {
        return testMode ? SuperNewsMockFileService(forceLoadFailure: false) : SuperNewsJSONFileService()
    }
}
