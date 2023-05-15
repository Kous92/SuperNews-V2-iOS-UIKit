//
//  ArticleDetailModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import Foundation
import UIKit

final class ArticleDetailModuleBuilder: ModuleBuilder {
    private var testMode = false
    private let articleViewModel: ArticleViewModel
    
    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let articleDetailViewController = ArticleDetailViewController()
        
        // Dependency injection. Don't forget to inject the coordinator delegate reference for navigation actions.
        let articleDetailViewModel = ArticleDetailViewModel(with: articleViewModel)
        articleDetailViewModel.coordinator = coordinator as? ArticleDetailViewControllerDelegate
        articleDetailViewController.configure(with: articleDetailViewModel)
        
        return articleDetailViewController
    }
}
