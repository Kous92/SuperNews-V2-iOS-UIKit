//
//  ArticleDetailCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import Foundation
import UIKit

// Ensure that the 4th and 5th SOLID principles are respected: Interface Segregation and Dependency Inversion
protocol ArticleDetailViewControllerDelegate: AnyObject {
    func backToPreviousScreen()
}

final class ArticleDetailCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[ArticleDetailCoordinator] Initializing.")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[ArticleDetailCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[ArticleDetailCoordinator] Instantiating SourceSelectionViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let articleDetailViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[ArticleDetailCoordinator] Article detail view ready.")
        navigationController.pushViewController(articleDetailViewController, animated: true)
        
        return navigationController
    }
}

extension SourceSelectionCoordinator: ArticleDetailViewControllerDelegate {
    func backToPreviousScreen() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)
    }
}
