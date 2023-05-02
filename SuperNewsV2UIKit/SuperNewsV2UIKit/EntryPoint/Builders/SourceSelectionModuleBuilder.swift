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
        let sourceSelectionViewController = SourceSelectionViewController()
        
        // Dependency injection
        let dataRepository = getRepository(testMode: testMode)
        let settingsRepository = getSettingsRepository(testMode: testMode)
        let useCase = SourceSelectionUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository)
        let sourceSelectionViewModel = SourceSelectionViewModel(useCase: useCase)
        sourceSelectionViewModel.coordinator = coordinator as? SourceSelectionViewControllerDelegate
        
        // Injecting view model
        sourceSelectionViewController.viewModel = sourceSelectionViewModel
        
        return sourceSelectionViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getSettingsRepository(testMode: Bool) -> SuperNewsSettingsRepository {
        return SuperNewsUserDefaultsRepository(settingsService: getSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getSettingsService(testMode: Bool) -> SuperNewsLocalSettings {
        return testMode ? SuperNewsMockLocalSettings() : SuperNewsUserDefaultsLocalSettings()
    }
}
