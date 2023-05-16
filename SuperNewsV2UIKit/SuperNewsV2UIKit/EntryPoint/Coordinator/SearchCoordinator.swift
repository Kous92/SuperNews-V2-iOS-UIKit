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
    func goToDetailArticleView(with articleViewModel: ArticleViewModel)
    func displayErrorAlert(with errorMessage: String)
}

final class SearchCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[SearchCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SearchCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[SearchCoordinator] Instantiating SearchViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let searchViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[SearchCoordinator] Search view ready.")
        navigationController.pushViewController(searchViewController, animated: false)
        
        return navigationController
    }
}

extension SearchCoordinator: SearchViewControllerDelegate {
    func goToDetailArticleView(with articleViewModel: ArticleViewModel) {
        // Transition is separated here into a child coordinator.
        print("[SearchCoordinator] Setting child coordinator: ArticleDetailSelectionCoordinator.")
        let articleDetailCoordinator = ArticleDetailCoordinator(navigationController: navigationController, builder: ArticleDetailModuleBuilder(articleViewModel: articleViewModel))
        
        // Adding link to the parent with self, be careful to retain cycle
        articleDetailCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: articleDetailCoordinator)
        
        // Transition from home screen to source selection screen
        print("[SearchCoordinator] Go to ArticleDetailViewController.")
        articleDetailCoordinator.start()
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SearchCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
