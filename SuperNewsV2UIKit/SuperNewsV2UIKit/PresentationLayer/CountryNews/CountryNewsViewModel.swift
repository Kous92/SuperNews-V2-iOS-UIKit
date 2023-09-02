//
//  CountryNewsViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 07/06/2023.
//

import Foundation
import Combine

final class CountryNewsViewModel {
    // Delegate
    weak var coordinator: CountryNewsViewControllerDelegate?
    
    private let countryCode: String
    private let useCase: CountryNewsUseCaseProtocol
    private var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    // MARK: - Bindings
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(countryCode: String, useCase: CountryNewsUseCaseProtocol) {
        self.countryCode = countryCode
        self.useCase = useCase
    }
    
    // MARK: - Top headlines
    func fetchCountryTopHeadlines() {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(countryCode: self.countryCode)
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[ArticleViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[CountryNewsViewModel] Data retrieved: \(viewModels.count) articles")
                self.articleViewModels = viewModels
                await parseViewModels()
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("[CountryNewsViewModel] ERROR: " + error.rawValue)
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
    
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return cellViewModels.count
    }
    
    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsCellViewModel? {
        // A TableView must have at least one section and one element on CellViewModels list, crash othervise
        let cellCount = cellViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return cellViewModels[indexPath.row]
    }
    
    func getCountryName() -> String {
        return countryCode.countryName()?.capitalized ?? "??"
    }
}

// Navigation part
extension CountryNewsViewModel {
    func backToPreviousScreen() {
        coordinator?.backToPreviousScreen()
    }
    
    func goToArticleDetailView(selectedViewModelIndex: Int) {
        print("[CountryNewsViewModel] TopHeadlines -> Coordinator -> ArticleDetail")
        print("[CountryNewsViewModel] ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
