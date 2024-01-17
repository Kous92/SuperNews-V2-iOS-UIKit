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
    func backToHomeView()
}

final class SourceSelectionCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    // le "testMode" n'a rien à faire dans l'initialisation de tes objets
    // à mon sens, il te faut un pattern plus agnostique
    // On va dire que tu as besoin d'une "Factory" qui va te générer tes sources de données
    // avec une idée comme :
//
//    protocol MyNewsSource {
//
//        func articles() -> [Article]
//    }
//
//    class LocalSource: MyNewsSource {
//
//    }
//
//    class ApiSource: MyNewsSource {
//
//    }
//
//    final class SourceFactory {
//
//        var newsSource: MyNewsSource
//    }

    // Ta factory est final, ses méthodes static, et tu viens piocher dedans
    // Ici le sourci est que tu dois déclarer un paramètre "inutile" à ton app, il l'est seulement à toi pour gérer ton mode dev/release, donc pas lié à ton code, mais ton processus de déploiement


    // Mais il peut exister plusieurs méthodes de travailler :
    // 1. utiliser les mode de compilation via des schemes de compilation / xcconfig et ainsi te créer un mode "local" & une mode "api"
    // 2. utiliser NodeJS pour te créer un mock server et ainsi simuler ton api en local sur ton poste et ainsi ne jamais toucher à ta codebase (à mon sens le mieux car te demande le moins de cabriole) et te permet d'être complètement étanche : ton app consome des données, sous un format définit, que ce soit d'un point X ou Y, du moment que ton jeux de données respecte le contrat, tout roule.

    // J'ai eu le débat il y a peu dans mon nouveau job, j'ai mock les micro-service que je devais utiliser car le dev étant réaliser en feature team, les devs back ont commencé en meme temps que le front. Mauvaise pratique j'en conviens, mais le fait est là, ce n'est pas la question.
    // J'ai recrée une petite API en local pour avoir mes jeux de donnes, et meme re-créer le comportement de l'API, certes cela m'a pris un peu de temps, mais je n'ai pas attendu derrière pour travailler.
    // Et également, cela a rendu mon code étanche au reste du monde, j'ai pu finir ma feature côté front, et livrer un code fonctionnel qui n'a pas eu besoin d'être retouché après dans sa partie "interface api".

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
    func backToHomeView() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)

    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[SourceSelectionCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
