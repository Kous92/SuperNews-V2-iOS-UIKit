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
    // Commentaire en 3 points qui vont se révéler valable partout où on retrouve le pattern :
    // donc je mets le commentaire juste ici, mais il est identique partout :

    // 1. Les Logs de debug
    // Pas de log, c'est pas bien
    // Peu de log, c'est toujours pas ouf
    // Des logs : c'est bien
    // Beaucoup de log : ça peut être utile
    // Trop de log : c'est trop

    // je pense que tu as compris l'idée, ici, et de manière, générale, il y en a trop.
    // Mettre un seul log dans une fonction de "deinit" n'a plus d'utilité quand tu as validé ton écran
    // I.E. tu as finis le dev, tu sais que ton écran tourne, tu n'as plus besoin de t'assurer que tout va bien dans ton run flow


    // 2. Utilises une class pour la gestion de tes logs afin de gagner du temps à ne pas C/C "[MonObjet][function()]" et ainsi faire un
    // private let logger = MyLogger()
    // Et bénéficier aussi de plusieurs méthodes de log de type
    // debug() / warn() / error()
    // A. Tu pourras depuis cette class gérer plus facilement ce qui sort dans ta console, comme par exemple un niveau de log, niveau que tu pourrais définir dans une variable de ton projet
    // B. Tu peux tout à fait récupérer ce que tu souhaites via les arguments #file / #function ... etc, plus d'info ici https://stackoverflow.com/a/41975817
    // C. Au release, pouvoir n'afficher que les logs de error() voir warn() et ainsi ne pas afficher trop d'info dans la console (tu peux retrouver tous les logs d'une app via console.app de MacOS)


    // 3. le "deinit" d'une class ne devrait pas avoir à s'implémenter car il t'indique que la class va sortir de la mémoire
    // préfère plutôt une méthode "end()" ou "destroy()" que tu appelles sur un disappear() d'un écran par exemple pour prouver que tu maitrises le run flow
    // Si tu arrives à implémenter le deinit d'une classe pour forcer la libération de tes objets enfants, c'est que propablement il y a un loup dans ton code, un listener system que tu as oublié de release ou encore un oubli d'un [weak self] qq part
    // En tout cas, fait bien attention au KVO que tu écoutes, notament si tu utilises AVFoundation pour la video ou l'audio, car meme en [weak self] dans une closure, le completion block que tu assignes à l'évènement ne sera pas relaché, il faudra que tu le spécifies toi même



    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SearchCoordinator] Coordinator destroyed.")
    }
    
    // Si je voulais chipoter, "start()" n'est pas forcément bien choisi comme naming. Cette fonction ne démarre rien du tout, elle prépare ou configure seulement ton objet
    // donc "prepare()" / "configure()" etc ...
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
    
    // Une simple recherche de "UIAlertController" me fait dire que tu aurais pu créer une extension sur UIViewController
    // comme ceci
    //
//    extension UIViewController {
//        func alert(title: String, message: String, titleAction: String, completion: @escaping ((UIAlertAction) -> Void)) {
//            ...
//        }
//    }
    // Et la réutiliser partout

    func displayErrorAlert(with errorMessage: String) {
        print("[SearchCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}

