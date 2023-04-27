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
    var viewModels = [NewsCellViewModel]()
    
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
            let result = await useCase.execute(source: "lequipe")
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlines(with category: String) {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(countryCode: "us", category: category)
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[NewsCellViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[HomeViewModel] Données récupérées: \(viewModels.count) articles")
                self.viewModels = viewModels
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                await self.sendErrorMessage(with: error.rawValue)
                self.updateResult.send(false)
        }
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
}
