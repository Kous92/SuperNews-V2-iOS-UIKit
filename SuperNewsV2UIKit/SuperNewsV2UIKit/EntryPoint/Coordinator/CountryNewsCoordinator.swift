//
//  CountryNewsCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 07/06/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
@MainActor protocol CountryNewsViewControllerDelegate: AnyObject {
    func backToPreviousScreen()
    func goToDetailArticleView(with articleViewModel: ArticleViewModel)
    func displayErrorAlert(with errorMessage: String)
}

@MainActor final class CountryNewsCoordinator: ParentCoordinator {
    // Attention à la rétention de cycle, le sous-flux ne doit pas retenir la référence avec le parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[CountryNewsCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[CountryNewsCoordinator] Coordinator destroyed.")
    }

    // Le pattern "discardableResult" n'est pas terrible car il sous entend que tu n'auras pas besoin du résultat.
    // Je crois comprendre que tu fais ça pour éviter les warnings du linter :
    // donc
    // soit tu fais un assignation vide  _ = myDiscardableFunction()
    // soit tu évites de l'utiliser
    // Parce que cela veut aussi dire qu'un return devient inutile
    
    @discardableResult func start() -> UIViewController {
        print("[CountryNewsCoordinator] Instantiating TopHeadlinesViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let countryNewsViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        print("[CountryNewsCoordinator] Country News view ready.")
        navigationController.pushViewController(countryNewsViewController, animated: true)
        
        return navigationController
    }
}

extension CountryNewsCoordinator: CountryNewsViewControllerDelegate {
    func backToPreviousScreen() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)
    }
    
    func goToDetailArticleView(with articleViewModel: ArticleViewModel) {
        // Transition is separated here into a child coordinator.
        print("[CountryNewsCoordinator] Setting child coordinator: ArticleDetailSelectionCoordinator.")
        let articleDetailCoordinator = ArticleDetailCoordinator(navigationController: navigationController, builder: ArticleDetailModuleBuilder(articleViewModel: articleViewModel))
        
        // Adding link to the parent with self, be careful to retain cycle
        articleDetailCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: articleDetailCoordinator)
        
        // Transition from home screen to source selection screen
        print("[CountryNewsCoordinator] Go to ArticleDetailViewController.")
        articleDetailCoordinator.start()
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[CountryNewsCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
