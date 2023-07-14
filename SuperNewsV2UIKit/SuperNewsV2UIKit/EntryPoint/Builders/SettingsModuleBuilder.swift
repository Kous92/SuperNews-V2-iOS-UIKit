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
        // let dataRepository = getRepository(testMode: testMode)
        // let useCase = SettingsUseCase(dataRepository: dataRepository)
        let settingsViewModel = SettingsViewModel()
        // settingsViewModel.coordinator = coordinator as? SettingsViewControllerDelegate
        
        // Injecting view model
        // countryNewsViewController.viewModel = countryNewsViewModel
        
        return settingsViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
}
