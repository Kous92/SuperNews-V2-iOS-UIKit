//
//  SettingsModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation
import UIKit

final class SettingsModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let settingsViewController = SettingsViewController()
        
        // Dependency injection
        let userSettingRepository = getUserSettingRepository(testMode: testMode)
        let resetUserSettingsUseCase = ResetUserSettingsUseCase(userSettingsRepository: userSettingRepository)
        let settingsViewModel = SettingsViewModel(resetUserSettingsUseCase: resetUserSettingsUseCase)
        settingsViewModel.coordinator = coordinator as? SettingsViewControllerDelegate
        
        // Injecting view model
        settingsViewController.viewModel = settingsViewModel
        
        return settingsViewController
    }
    
    private func getUserSettingRepository(testMode: Bool) -> SuperNewsUserSettingsRepository {
        return SuperNewsUserSettingsRepository(settingsService: getUserSettingsService(testMode: testMode))
    }
    
    private func getUserSettingsService(testMode: Bool) -> SuperNewsUserSettings {
        return testMode ? SuperNewsUserDefaultsCountryLanguageSettings(with: "reset") : SuperNewsUserDefaultsCountryLanguageSettings(with: "reset")
    }
}
