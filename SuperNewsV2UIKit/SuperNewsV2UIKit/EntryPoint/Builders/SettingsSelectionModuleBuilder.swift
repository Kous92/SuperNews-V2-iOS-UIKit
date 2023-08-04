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
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let settingsSelectionViewController = SettingsSelectionViewController()
        
        // Dependency injection
        // let dataRepository = getRepository(testMode: testMode)
        // let useCase = SettingsUseCase(dataRepository: dataRepository)
        let settingsSelectionViewModel = SettingsSelectionViewModel()
        settingsSelectionViewModel.coordinator = coordinator as? SettingsSelectionViewControllerDelegate
        
        // Injecting view model
        settingsSelectionViewController.viewModel = settingsSelectionViewModel
        
        return settingsSelectionViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
}
