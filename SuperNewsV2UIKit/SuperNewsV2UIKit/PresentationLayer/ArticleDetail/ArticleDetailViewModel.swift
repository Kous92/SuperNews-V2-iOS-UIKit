//
//  ArticleDetailViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/05/2023.
//

import Foundation
import Combine

final class ArticleDetailViewModel {
    // Delegate
    weak var coordinator: ArticleDetailViewControllerDelegate?
    private let articleViewModel: ArticleViewModel
    
    // Bindings
    private var updateResult = PassthroughSubject<ArticleViewModel, Never>()
    var updateResultPublisher: AnyPublisher<ArticleViewModel, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    // Dependency injection
    init(with articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }
    
    func updateArticleView() {
        print("[ArticleDetailViewModel] Updating view with article data...")
        updateResult.send(articleViewModel)
    }
}

extension ArticleDetailViewModel {
    func backToPreviousScreen() {
        coordinator?.backToPreviousScreen()
    }
    
    func openShareSheetWindow() {
        coordinator?.openShareSheet(articleTitle: articleViewModel.title, websiteURL: articleViewModel.sourceUrl)
    }
    
    func openArticleWebsite() {
        print("[ArticleDetailViewModel] Opening Safari from Coordinator...")
        coordinator?.openSafariWithArticleWebsite(websiteURL: articleViewModel.sourceUrl)
    }
}
