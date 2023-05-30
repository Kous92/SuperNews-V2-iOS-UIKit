//
//  MapViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import Combine
import CoreLocation

final class MapViewModel {
    private var annotationsViewModels = [CountryAnnotationViewModel]()
    
    // Delegate
    weak var coordinator: MapViewControllerDelegate?
    private let useCase: MapUseCaseProtocol
    
    // MARK: - Bindings
    private var userLocation = PassthroughSubject<CLLocation, SuperNewsGPSError>()
    private var countryAnnotations = PassthroughSubject<Bool, Never>()
    
    var userLocationPublisher: AnyPublisher<CLLocation, SuperNewsGPSError> {
        return userLocation.eraseToAnyPublisher()
    }
    
    var countryAnnotationPublisher: AnyPublisher<Bool, Never> {
        return countryAnnotations.eraseToAnyPublisher()
    }
    
    init(useCase: MapUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func getLocation() {
        Task {
            print("[MapViewModel] Getting user location")
            let result = await useCase.fetchUserLocation()
            
            switch result {
                case .success(let userCoordinates):
                    print("[MapViewModel] User location retrieved, ready for map with coordinates: x = \(userCoordinates.coordinate.longitude), y = \(userCoordinates.coordinate.latitude)")
                    self.userLocation.send(userCoordinates)
                case .failure(let error):
                    print("[MapViewModel] Impossible to retrieve user location.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    func loadCountries() {
        Task {
            print("[MapViewModel] Loading countries")
            let result = await useCase.execute()
            
            switch result {
                case .success(let annotations):
                    self.annotationsViewModels = annotations
                    print("[MapViewModel] Countries loaded successfully, ready to display on map")
                    self.countryAnnotations.send(true)
                case .failure(let error):
                    print("[MapViewModel] Loading failed.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func getAnnotationViewModels() -> [CountryAnnotationViewModel] {
        return annotationsViewModels
    }
}

// Navigation part
extension MapViewModel {
    
}
