//
//  SearchViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/05/2023.
//

import Foundation
import Combine

final class SearchViewModel {
    // Delegate
    weak var coordinator: SearchViewControllerDelegate?
    
    private let useCase: SearchUseCaseProtocol
    private var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    // MARK: - Bindings and subscriptions
    @Published var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(useCase: SearchUseCaseProtocol) {
        self.useCase = useCase
        setBindings()
    }
    
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.fetchNewsWithQuery()
            }.store(in: &subscriptions)
    }
    
    private func fetchNewsWithQuery() {
        // Contenu vide
        guard !searchQuery.isEmpty else {
            print("[SearchViewModel] Nothing to search, ignoring fetching data from network.")
            return
        }
        
        Task {
            isLoading.send(true)
            let result = await useCase.execute(searchQuery: searchQuery, language: "fr", sortBy: "publishedAt")
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[ArticleViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[TopHeadlinesViewModel] Données récupérées: \(viewModels.count) articles")
                self.articleViewModels = viewModels
                await parseViewModels()
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("ERROR: " + error.rawValue)
                await self.sendErrorMessage(with: error.rawValue)
                self.updateResult.send(false)
        }
    }
    
    private func parseViewModels() async {
        cellViewModels = articleViewModels.map { $0.getNewsCellViewModel() }
    }
    
    // MARK: - TableView logic
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
}

// Navigation part
extension SearchViewModel {
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func goToArticleDetailView(selectedViewModelIndex: Int) {
        print("[SearchViewModel] Search -> Coordinator -> ArticleDetail")
        print("ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
