//
//  SettingsSelectionCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol SettingsSelectionViewControllerDelegate: AnyObject {
    func backToPreviousScreen()
    func displayErrorAlert(with errorMessage: String)
}

final class SettingsSelectionCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[SettingsSelectionCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SettingsSelectionCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[SettingsSelectionCoordinator] Instantiating SettingsSelectionViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsSelectionViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[SettingsSelectionCoordinator] Settings selection view ready.")
        navigationController.pushViewController(settingsSelectionViewController, animated: true)
        
        return navigationController
    }
}

extension SettingsSelectionCoordinator: SettingsSelectionViewControllerDelegate {
    func backToPreviousScreen() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SettingsSelectionCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
