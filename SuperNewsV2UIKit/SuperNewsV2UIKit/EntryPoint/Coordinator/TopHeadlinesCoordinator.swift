//
//  TopHeadlinesCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol TopHeadlinesViewControllerDelegate: AnyObject {
    func goToDetailArticleView(with articleViewModel: ArticleViewModel)
    func goToSourceSelectionView()
    func displayErrorAlert(with errorMessage: String)
}

final class TopHeadlinesCoordinator: ParentCoordinator {
    // Attention à la rétention de cycle, le sous-flux ne doit pas retenir la référence avec le parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[TopHeadlinesCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[TopHeadlinesCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {        
        print("[TopHeadlinesCoordinator] Instantiating TopHeadlinesViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let topHeadlinesViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[TopHeadlinesCoordinator] Top Headlines view ready.")
        navigationController.pushViewController(topHeadlinesViewController, animated: false)
        
        return navigationController
    }
}

extension TopHeadlinesCoordinator: TopHeadlinesViewControllerDelegate {
    
    func goToDetailArticleView(with articleViewModel: ArticleViewModel) {
        // Transition is separated here into a child coordinator.
        print("[TopHeadlinesCoordinator] Setting child coordinator: ArticleDetailSelectionCoordinator.")
        let articleDetailCoordinator = ArticleDetailCoordinator(navigationController: navigationController, builder: ArticleDetailModuleBuilder(articleViewModel: articleViewModel))
        
        // Adding link to the parent with self, be careful to retain cycle
        articleDetailCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: articleDetailCoordinator)
        
        // Transition from home screen to source selection screen
        print("[TopHeadlinesCoordinator] Go to ArticleDetailViewController.")
        articleDetailCoordinator.start()
    }
    
    func goToSourceSelectionView() {
        // Transition is separated here into a child coordinator.
        print("[TopHeadlinesCoordinator] Setting child coordinator: SourceSelectionCoordinator.")
        let sourceSelectionCoordinator = SourceSelectionCoordinator(navigationController: navigationController, builder: SourceSelectionModuleBuilder())
        
        // Adding link to the parent with self, be careful to retain cycle
        sourceSelectionCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: sourceSelectionCoordinator)
        
        // Transition from home screen to source selection screen
        print("[TopHeadlinesCoordinator] Go to SourceSelectionViewController.")
        sourceSelectionCoordinator.start()
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[TopHeadlinesCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
