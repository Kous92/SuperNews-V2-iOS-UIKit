//
//  AppCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit


/// The main app Coordinator, the root of navigation flow
final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let homeCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder())
    private let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
    private let rootViewController: UIViewController
    
    init(with rootViewController: UIViewController = UITabBarController()) {
        self.rootViewController = rootViewController
    }
    
    func start() -> UIViewController {
        let topHeadlinesViewController = homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        topHeadlinesViewController.tabBarItem = UITabBarItem(title: "Actualités", image: UIImage(systemName: "newspaper"), tag: 0)
        
        let searchViewController = searchCoordinator.start()
        searchCoordinator.parentCoordinator = self
        searchViewController.tabBarItem = UITabBarItem(title: "Recherche", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        (rootViewController as? UITabBarController)?.viewControllers = [topHeadlinesViewController, searchViewController]
                
        return rootViewController
    }
}

/*
extension AppCoordinator: TopHeadlinesViewControllerDelegate {
    func goToListView() {
        // La transition est séparée ici dans un sous-flux
        let listCoordinator = ListCoordinator(navigationController: navigationController)
        
        // Ajout du lien vers le parent avec self, attention à la rétention de cycle
        listCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: listCoordinator)
        
        // On transite de l'écran liste à l'écran détail
        listCoordinator.start()
    }
}
*/
