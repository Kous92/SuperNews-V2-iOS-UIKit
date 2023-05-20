//
//  MapViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import Combine

final class MapViewModel {
    // Delegate
    weak var coordinator: MapViewControllerDelegate?
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
}

// Navigation part
extension MapViewModel {
    
}
