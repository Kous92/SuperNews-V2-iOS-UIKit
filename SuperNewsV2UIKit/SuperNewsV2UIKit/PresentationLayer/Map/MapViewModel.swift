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
    // Delegate
    weak var coordinator: MapViewControllerDelegate?
    private let useCase: MapUseCaseProtocol
    
    // MARK: - Bindings
    private var userLocation = PassthroughSubject<CLLocation, SuperNewsGPSError>()
    // private var
    
    var userLocationPublisher: AnyPublisher<CLLocation, SuperNewsGPSError> {
        return userLocation.eraseToAnyPublisher()
    }
    
    /*
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
     */
    
    init(useCase: MapUseCaseProtocol) {
        self.useCase = useCase
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
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
                    print("[MapViewModel] Impossible to retriver user location.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
}

// Navigation part
extension MapViewModel {
    
}
