//
//  SourceSelectionCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/04/2023.
//

import Foundation
import UIKit

// Ensure that the 4th and 5th SOLID principles are respected: Interface Segregation and Dependency Inversion
protocol SourceSelectionViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
    func backToHomeView(with selectedSourceId: String)
}

final class SourceSelectionCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    weak var delegate: SourceToHomeControllerDelegate?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[SourceSelectionCoordinator] Initializing.")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SourceSelectionCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[SourceSelectionCoordinator] Instantiating SourceSelectionViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let sourceSelectionViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[SourceSelectionCoordinator] Source selection view ready.")
        navigationController.pushViewController(sourceSelectionViewController, animated: true)
        
        return navigationController
    }
}

extension SourceSelectionCoordinator: SourceSelectionViewControllerDelegate {
    func backToHomeView(with selectedSourceId: String) {
        delegate?.backToHomeView(with: selectedSourceId)
        navigationController.popViewController(animated: true)
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SourceSelectionCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
