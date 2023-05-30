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
        let searchViewController = SearchViewController()
        
        // Dependency injection
        let dataRepository = getRepository(testMode: testMode)
        let settingsRepository = getSettingsRepository(testMode: testMode)
        let useCase = SearchUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository)
        let searchViewModel = SearchViewModel(useCase: useCase)
        searchViewModel.coordinator = coordinator as? SearchViewControllerDelegate
        
        // Injecting view model
        searchViewController.viewModel = searchViewModel
        
        return searchViewController
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