//
//  SearchBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/05/2023.
//

import Foundation
import UIKit

final class SearchModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let searchViewController = SearchViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let dataRepository = getRepository(testMode: testMode)
        let userSettingsRepository = getUserSettingsRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let searchUseCase = SearchUseCase(dataRepository: dataRepository)
        let loadUserSettingsUseCase = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase)
        
        // 4) Injecting coordinator for presentation layer
        searchViewModel.coordinator = coordinator as? SearchViewControllerDelegate
        
        // 5) Injecting view model to the view
        searchViewController.viewModel = searchViewModel
        
        return searchViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getUserSettingsRepository(testMode: Bool) -> SuperNewsSettingsRepository {
        return SuperNewsUserSettingsRepository(settingsService: getUserSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getUserSettingsService(testMode: Bool) -> SuperNewsUserSettings {
        return testMode ? SuperNewsMockCountryLanguageSettings(with: "language") : SuperNewsUserDefaultsCountryLanguageSettings(with: "language")
    }
}
