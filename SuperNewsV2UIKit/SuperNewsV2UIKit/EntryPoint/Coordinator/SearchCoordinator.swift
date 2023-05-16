//
//  SearchCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol SearchViewControllerDelegate: AnyObject {
    
}

final class SearchCoordinator: ParentCoordinator, SearchViewControllerDelegate {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        print("[SearchCoordinator] Initializing coordinator")
        self.navigationController = navigationController
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SearchCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[SearchCoordinator] Instantiating SearchViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: false)
        print("[SearchCoordinator] Search view ready.")
        
        return navigationController
    }
}
