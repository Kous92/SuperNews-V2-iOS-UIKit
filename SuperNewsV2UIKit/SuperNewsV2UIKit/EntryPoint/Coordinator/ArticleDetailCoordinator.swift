//
//  ArticleDetailCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import Foundation
import UIKit
import SafariServices

// Ensure that the 4th and 5th SOLID principles are respected: Interface Segregation and Dependency Inversion
protocol ArticleDetailViewControllerDelegate: AnyObject {
    func backToPreviousScreen()
    func openSafariWithArticleWebsite(websiteURL: String)
    func openShareSheet(articleTitle: String, websiteURL: String)
}

final class ArticleDetailCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the subflow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[ArticleDetailCoordinator] Initializing.")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[ArticleDetailCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[ArticleDetailCoordinator] Instantiating SourceSelectionViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let articleDetailViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[ArticleDetailCoordinator] Article detail view ready.")
        navigationController.pushViewController(articleDetailViewController, animated: true)
        
        return navigationController
    }
}

extension ArticleDetailCoordinator: ArticleDetailViewControllerDelegate {
    func backToPreviousScreen() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)
    }
    
    func openSafariWithArticleWebsite(websiteURL: String) {
        guard let url = URL(string: websiteURL) else {
            // Display an alert
            let alert = UIAlertController(title: String(localized: "error"), message: "Une erreur est survenue pour l'ouverture du navigateur avec le lien suivant: \(websiteURL).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            navigationController.present(alert, animated: true)
            
            return
        }
        
        // Opening the browser
        let safari = SFSafariViewController(url: url)
        navigationController.present(safari, animated: true)
    }
    
    func openShareSheet(articleTitle: String, websiteURL: String) {
        guard let url = URL(string: websiteURL) else {
            // Display an alert
            let alert = UIAlertController(title: String(localized: "error"), message: "Une erreur est survenue avec le lien suivant: \(websiteURL).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            navigationController.present(alert, animated: true)
            
            return
        }
        
        let items = [articleTitle, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        guard navigationController.topViewController is ArticleDetailViewController else {
            print("[ArticleDetailCoordinator] ERROR: The ArticleDetailViewController UINavigationController is not present, cannot find the right bar button item to set the popover (for iPad).")
            
            return
        }
        
        // To avoid crash on iPad. It needs to use a popover and it must define from where the share sheet will be displayed, not like an iPhone.
        if let popover = activityViewController.popoverPresentationController {
            popover.barButtonItem = navigationController.topViewController?.navigationItem.rightBarButtonItem
        }
            
        navigationController.present(activityViewController, animated: true)
    }
}
