//
//  HomeCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit

// On respecte les 4ème et 5ème principe du SOLID de la ségrégation d'interface et de l'inversion de dépendances
protocol HomeViewControllerDelegate: AnyObject {
    func goToDetailArticleView()
    func displayErrorAlert(with errorMessage: String)
}

final class HomeCoordinator: ParentCoordinator {
    // Attention à la rétention de cycle, le sous-flux ne doit pas retenir la référence avec le parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[HomeCoordinator] Initialising")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // À titre d'exemple pour vérifier que lorsqu'on retourne sur l'écran d'accueil qu'il n'y a pas de memory leak
    deinit {
        print("[HomeCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {        
        print("[HomeCoordinator] Instantiating HomeViewController.")
        let homeViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        // On n'oublie pas de faire l'injection de dépendance du ViewModel
        print("[HomeCoordinator] Home view ready.")
        navigationController.pushViewController(homeViewController, animated: false)
        
        return navigationController
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func goToDetailArticleView() {
        
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[HomeCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
