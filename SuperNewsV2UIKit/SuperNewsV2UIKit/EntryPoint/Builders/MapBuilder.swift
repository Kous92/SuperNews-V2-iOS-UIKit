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
        // Get ViewController instance: view layer
        let mapViewController = MapViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let locationRepository = getLocationRepository(testMode: testMode)
        let localFileRepository = getLocalFileRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let mapUseCase = MapUseCase(localFileRepository: localFileRepository)
        let fetchUserLocationUseCase = FetchUserLocationUseCase(locationRepository: locationRepository)
        let reverseGeocodingUseCase = ReverseGeocodingUseCase(locationRepository: locationRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let mapViewModel = MapViewModel(mapUseCase: mapUseCase, fetchUserLocationUseCase: fetchUserLocationUseCase, reverseGeocodingUseCase: reverseGeocodingUseCase)
        
        // 4) Injecting coordinator for presentation layer
        mapViewModel.coordinator = coordinator as? MapViewControllerDelegate
        
        // 5) Injecting view model to the view
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
