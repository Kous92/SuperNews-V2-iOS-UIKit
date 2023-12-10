//
//  SourceSelectionModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/04/2023.
//

import Foundation
import UIKit

final class SourceSelectionModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let sourceSelectionViewController = SourceSelectionViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let dataRepository = getRepository(testMode: testMode)
        let sourceSettingsRepository = getSettingsRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let sourceSelectionUseCase = SourceSelectionUseCase(dataRepository: dataRepository)
        let saveSelectedSourceUseCase = SaveSelectedSourceUseCase(sourceSettingsRepository: sourceSettingsRepository)
        let loadSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(sourceSettingsRepository: sourceSettingsRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let sourceSelectionViewModel = SourceSelectionViewModel(sourceSelectionUseCase: sourceSelectionUseCase, loadSelectedSourceUseCase: loadSelectedSourceUseCase, saveSelectedSourceUseCase: saveSelectedSourceUseCase)
        
        // 4) Injecting coordinator for presentation layer
        sourceSelectionViewModel.coordinator = coordinator as? SourceSelectionViewControllerDelegate
        
        // 5) Injecting view model to the view
        sourceSelectionViewController.viewModel = sourceSelectionViewModel
        
        return sourceSelectionViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getSettingsRepository(testMode: Bool) -> SuperNewsSourceSettingsRepository {
        return SuperNewsSourceUserDefaultsRepository(settingsService: getSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getSettingsService(testMode: Bool) -> SuperNewsLocalSettings {
        return testMode ? SuperNewsMockLocalSettings() : SuperNewsUserDefaultsLocalSettings()
    }
}
