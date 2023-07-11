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
        let locationRepository = getLocationRepository(testMode: testMode)
        let localFileRepository = getLocalFileRepository(testMode: testMode)
        let useCase = MapUseCase(locationRepository: locationRepository, localFileRepository: localFileRepository)
        let mapViewModel = MapViewModel(useCase: useCase)
        
        mapViewModel.coordinator = coordinator as? MapViewControllerDelegate
        
        // Injecting view model
        mapViewController.viewModel = mapViewModel
        
        return mapViewController
    }
    
    private func getLocationRepository(testMode: Bool) -> SuperNewsLocationRepository {
        return SuperNewsGPSRepository(locationService: getLocationService(testMode: testMode))
    }
    
    private func getLocalFileRepository(testMode: Bool) -> SuperNewsLocalFileRepository {
        return SuperNewsJSONFileRepository(localFileService: getLocalFileService(testMode: testMode))
    }
    
    private func getLocationService(testMode: Bool) -> SuperNewsLocationService {
        return testMode ? SuperNewsMockLocationService(forceFetchFailure: false) : SuperNewsGPSLocationService()
    }
    
    private func getLocalFileService(testMode: Bool) -> SuperNewsLocalDataFileService {
        return testMode ? SuperNewsJSONFileService() : SuperNewsJSONFileService()
    }
}
