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
        let settingsSelectionViewController = SettingsSelectionViewController()
        
        // Dependency injection
        let userSettingRepository = getUserSettingRepository(testMode: testMode)
        let localFileRepository = getLocalFileRepository(testMode: testMode)
        let useCase = UserSettingsUseCase(userSettingsRepository: userSettingRepository, localFileRepository: localFileRepository)
        let settingsSelectionViewModel = SettingsSelectionViewModel(settingSection: settingSection, useCase: useCase)
        settingsSelectionViewModel.coordinator = coordinator as? SettingsSelectionViewControllerDelegate
        
        // Injecting view model
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
        return testMode ? SuperNewsJSONFileService() : SuperNewsJSONFileService()
    }
}
