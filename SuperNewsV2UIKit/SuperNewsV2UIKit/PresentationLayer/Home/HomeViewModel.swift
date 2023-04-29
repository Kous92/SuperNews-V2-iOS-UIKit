//
//  HomeViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation
import Combine

final class HomeViewModel {
    weak var coordinator: HomeViewControllerDelegate?
    private let useCase: TopHeadlinesUseCaseProtocol
    private(set) var categoryViewModels = [NewsCellViewModel]()
    private(set) var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    // Bindings
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(useCase: TopHeadlinesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchTopHeadlines() {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .localCountryNews(countryCode: "fr"))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlines(with category: String) {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .categoryNews(name: category, countryCode: "us"))
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[ArticleViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[HomeViewModel] Données récupérées: \(viewModels.count) articles")
                self.articleViewModels = viewModels
                await parseViewModels()
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                await self.sendErrorMessage(with: error.rawValue)
                self.updateResult.send(false)
        }
    }
    
    private func parseViewModels() async {
        cellViewModels = articleViewModels.map { $0.getNewsCellViewModel() }
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
}
