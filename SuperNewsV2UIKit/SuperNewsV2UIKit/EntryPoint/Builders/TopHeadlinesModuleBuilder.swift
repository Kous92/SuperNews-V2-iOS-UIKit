//
//  TopHeadlinesModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import Foundation
import UIKit

final class TopHeadlinesModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let topHeadlinesViewController = TopHeadlinesViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let dataRepository = getRepository(testMode: testMode)
        let sourceSettingsRepository = getSettingsRepository(testMode: testMode)
        let userSettingsRepository = getUserSettingsRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let topHeadlinesUseCase = TopHeadlinesUseCase(dataRepository: dataRepository)
        let loadSavedSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(sourceSettingsRepository: sourceSettingsRepository)
        let loadUserSettingsUseCase = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let topHeadlinesViewModel = TopHeadlinesViewModel(topHeadlinesUseCase: topHeadlinesUseCase, loadSavedSelectedSourceUseCase: loadSavedSelectedSourceUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase)
        
        // 4) Injecting coordinator for presentation layer
        topHeadlinesViewModel.coordinator = coordinator as? TopHeadlinesViewControllerDelegate
        
        // Injecting view model to the view
        topHeadlinesViewController.viewModel = topHeadlinesViewModel
        
        return topHeadlinesViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getSettingsRepository(testMode: Bool) -> SuperNewsSourceSettingsRepository {
        return SuperNewsSourceUserDefaultsRepository(settingsService: getSettingsService(testMode: testMode))
    }
    
    private func getUserSettingsRepository(testMode: Bool) -> SuperNewsSettingsRepository {
        return SuperNewsUserSettingsRepository(settingsService: getUserSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getSettingsService(testMode: Bool) -> SuperNewsLocalSettings {
        return testMode ? SuperNewsMockLocalSettings() : SuperNewsUserDefaultsLocalSettings()
    }
    
    private func getUserSettingsService(testMode: Bool) -> SuperNewsUserSettings {
        return testMode ? SuperNewsMockCountryLanguageSettings(with: "country") : SuperNewsUserDefaultsCountryLanguageSettings(with: "country")
    }
}
