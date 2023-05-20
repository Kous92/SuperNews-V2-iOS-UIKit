//
//  MapCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol MapViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
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
    /*
    func goToDetailArticleView(with articleViewModel: ArticleViewModel) {
        // Transition is separated here into a child coordinator.
        print("[MapCoordinator] Setting child coordinator: ArticleDetailSelectionCoordinator.")
        let articleDetailCoordinator = ArticleDetailCoordinator(navigationController: navigationController, builder: ArticleDetailModuleBuilder(articleViewModel: articleViewModel))
        
        // Adding link to the parent with self, be careful to retain cycle
        articleDetailCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: articleDetailCoordinator)
        
        // Transition from home screen to source selection screen
        print("[SearchCoordinator] Go to ArticleDetailViewController.")
        articleDetailCoordinator.start()
    }
     */
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SearchCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
