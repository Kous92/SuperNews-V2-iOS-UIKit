//
//  SettingsCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol SettingsViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
}

final class SettingsCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[SettingsCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SettingsCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[SettingsCoordinator] Instantiating SettingsiewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[MapCoordinator] Map view ready.")
        navigationController.pushViewController(settingsViewController, animated: false)
        
        return navigationController
    }
}
