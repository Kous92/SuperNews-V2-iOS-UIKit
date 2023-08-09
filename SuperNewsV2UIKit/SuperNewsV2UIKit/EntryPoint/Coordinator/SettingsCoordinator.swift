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
    func goToSettingsSelectionView(settingSection: SettingsSection)
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
    
    @discardableResult func start() -> UIViewController {
        print("[SettingsCoordinator] Instantiating SettingsViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[MapCoordinator] Settings view ready.")
        navigationController.pushViewController(settingsViewController, animated: false)
        
        return navigationController
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func displayErrorAlert(with errorMessage: String) {
        print("[SettingsCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func goToSettingsSelectionView(settingSection: SettingsSection) {
        // Transition is separated here into a child coordinator.
        print("[SettingsCoordinator] Setting child coordinator: SettingsSelectionCoordinator.")
        let settingsSelectionCoordinator = SettingsSelectionCoordinator(navigationController: navigationController, builder: SettingsSelectionModuleBuilder(settingSection: settingSection))
        
        // Adding link to the parent with self, be careful to retain cycle
        settingsSelectionCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: settingsSelectionCoordinator)
        
        // Transition from settings screen to settings selection screen
        print("[SettingsCoordinator] Go to SettingsSelectionViewController.")
        settingsSelectionCoordinator.start()
    }
}
