//
//  MapCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import UIKit
import CoreLocation
import Combine

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol MapViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
    func goToCountryNewsView(countryCode: String)
    func displaySuggestedLocationAlert(with actualLocation: (location: CLLocation, countryName: String), to suggestedLocation: (location: CLLocation, countryName: String), completion: @escaping (_ answer: Bool) -> ())
}

final class MapCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[MapCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[MapCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[MapCoordinator] Instantiating MapViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let mapViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[MapCoordinator] Map view ready.")
        navigationController.pushViewController(mapViewController, animated: false)
        
        return navigationController
    }
}

extension MapCoordinator: MapViewControllerDelegate {
    func goToCountryNewsView(countryCode: String) {
        // Transition is separated here into a child coordinator.
        print("[MapCoordinator] Setting child coordinator: CountryNewsCoordinator.")
        let countryNewsCoordinator = CountryNewsCoordinator(navigationController: navigationController, builder: CountryNewsModuleBuilder(countryCode: countryCode))
        
        // Adding link to the parent with self, be careful to retain cycle
        countryNewsCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: countryNewsCoordinator)
        
        // Transition from home screen to source selection screen
        print("[MapCoordinator] Go to CountryNewsViewController.")
        countryNewsCoordinator.start()
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SearchCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func displaySuggestedLocationAlert(with actualLocation: (location: CLLocation, countryName: String), to suggestedLocation: (location: CLLocation, countryName: String), completion: @escaping (_ answer: Bool) -> ()) {
        print("[SearchCoordinator] Displaying error alert.")
        
        var message = ""
        
        if actualLocation.countryName == suggestedLocation.countryName {
            message = "Vous êtes localisé dans le même pays que celui est disponible sur la carte, ici: \(actualLocation.countryName). Voulez-vous centrer la carte sur la source du pays ? Sinon, la carte sera centrée sur votre position actuelle."
        } else {
            message = "Vous êtes localisé dans un pays (\(actualLocation.countryName)) qui n'est pas disponible sur la carte. Le pays le plus proche qui est suggéré est: \(suggestedLocation.countryName). Voulez-vous centrer la carte sur la source du pays suggéré ? Sinon, la carte sera centrée sur votre position actuelle."
        }
        
        let alert = UIAlertController(title: "Suggestion", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .default, handler: { _ in
            completion(false)
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
