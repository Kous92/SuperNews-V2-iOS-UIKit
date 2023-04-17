//
//  SearchCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit

// On respecte les 4ème et 5ème principe du SOLID de la ségrégation d'interface et de l'inversion de dépendances
protocol SearchViewControllerDelegate: AnyObject {
    
}

final class SearchCoordinator: ParentCoordinator, SearchViewControllerDelegate {
    // Attention à la rétention de cycle, le sous-flux ne doit pas retenir la référence avec le parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        print("[SearchCoordinator] Initialising")
        self.navigationController = navigationController
    }
    
    // À titre d'exemple pour vérifier que lorsqu'on retourne sur l'écran d'accueil qu'il n'y a pas de memory leak.
    deinit {
        print("[SearchCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[SearchCoordinator] Instantiating SearchViewController.")
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        
        // On n'oublie pas de faire l'injection de dépendance du ViewModel
        print("[SearchCoordinator] Search view ready.")
        
        return searchViewController
    }
}
