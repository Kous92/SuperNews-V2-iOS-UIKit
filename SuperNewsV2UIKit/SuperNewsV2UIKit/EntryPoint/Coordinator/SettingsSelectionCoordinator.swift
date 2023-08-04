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
    
    func start() -> UIViewController {
        print("[SettingsSelectionCoordinator] Instantiating SettingsSelectionViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsSelectionViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[MapCoordinator] Settings view ready.")
        navigationController.pushViewController(settingsSelectionViewController, animated: false)
        
        return navigationController
    }
}
