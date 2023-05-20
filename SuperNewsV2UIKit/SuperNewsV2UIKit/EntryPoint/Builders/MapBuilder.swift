//
//  MapBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import UIKit

final class MapModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let mapViewController = MapViewController()
        
        // Dependency injection
        // let dataRepository = getRepository(testMode: testMode)
        // let settingsRepository = getSettingsRepository(testMode: testMode)
        // let useCase = MapUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository)
        // let mapViewModel = MapViewModel(useCase: useCase)
        let mapViewModel = MapViewModel()
        mapViewModel.coordinator = coordinator as? MapViewControllerDelegate
        
        // Injecting view model
        mapViewController.viewModel = mapViewModel
        
        return mapViewController
    }
    
    /*
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
     */
}
