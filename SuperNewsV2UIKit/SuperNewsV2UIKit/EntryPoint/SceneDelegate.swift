//
//  SceneDelegate.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // It's important to keep here a strong reference for navigation flow management.
    private var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // The very first pushed ViewController from the Coordinator, which will host all main ViewControllers. With iOS 26.0 at least, it will have the Liquid Glass effect.
        let tabBar = TabBarCellFactory.getTabBar()
        
        // It's from here where we start the app and here where we start with the coordinator
        print("[SceneDelegate] Initializing the root coordinator: AppCoordinator")
        coordinator = AppCoordinator(with: tabBar)
        print("[SceneDelegate] Opening first view")
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // If we define the enty point in a programmatic way, the window must have set a root view, here the NavigationController where views will be pushed.
        window?.rootViewController = coordinator?.start()
        window?.makeKeyAndVisible()
    }
}
