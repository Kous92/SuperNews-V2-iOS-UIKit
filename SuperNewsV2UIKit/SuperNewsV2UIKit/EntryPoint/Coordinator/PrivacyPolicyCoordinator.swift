//
//  PrivacyPolicyCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol PrivacyPolicyViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
}

final class PrivacyPolicyCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[PrivacyPolicyCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[PrivacyPolicyCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[PrivacyPolicyCoordinator] Instantiating PrivacyPolicyViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[PrivacyPolicyCoordinator] Privacy policy view ready.")
        navigationController.pushViewController(settingsViewController, animated: true)
        
        return navigationController
    }
}

extension PrivacyPolicyCoordinator: PrivacyPolicyViewControllerDelegate {
    func displayErrorAlert(with errorMessage: String) {
        print("[PrivacyPolicyCoordinator] Displaying error alert.")
        let localizedErrorMessage = String(localized: String.LocalizationValue(errorMessage))
        let alert = UIAlertController(title: String(localized: "error"), message: localizedErrorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
