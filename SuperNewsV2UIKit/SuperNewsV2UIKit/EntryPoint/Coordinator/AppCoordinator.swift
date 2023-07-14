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
    private let topHeadlinesCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder())
    private let searchCoordinator = SearchCoordinator(navigationController: UINavigationController(), builder: SearchModuleBuilder())
    private let mapCoordinator = MapCoordinator(navigationController: UINavigationController(), builder: MapModuleBuilder())
    private let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController(), builder: SettingsModuleBuilder())
    private let rootViewController: UIViewController
    
    init(with rootViewController: UIViewController = UITabBarController()) {
        print("[AppCoordinator] Initializing main coordinator")
        self.rootViewController = rootViewController
    }
    
    func start() -> UIViewController {
        print("[AppCoordinator] Setting root view with TabBarController")
        let topHeadlinesViewController = topHeadlinesCoordinator.start()
        topHeadlinesCoordinator.parentCoordinator = self
        topHeadlinesViewController.tabBarItem = UITabBarItem(title: "Actualités", image: UIImage(systemName: "newspaper"), tag: 0)
        
        let searchViewController = searchCoordinator.start()
        searchCoordinator.parentCoordinator = self
        searchViewController.tabBarItem = UITabBarItem(title: "Recherche", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let mapViewController = mapCoordinator.start()
        mapCoordinator.parentCoordinator = self
        mapViewController.tabBarItem = UITabBarItem(title: "Carte du monde", image: UIImage(systemName: "map"), tag: 2)
        
        let settingsViewController = settingsCoordinator.start()
        settingsCoordinator.parentCoordinator = self
        settingsViewController.tabBarItem = UITabBarItem(title: "Paramètres", image: UIImage(systemName: "gear"), tag: 2)
        
        (rootViewController as? UITabBarController)?.viewControllers = [topHeadlinesViewController, searchViewController, mapViewController, settingsViewController]
                
        return rootViewController
    }
}
