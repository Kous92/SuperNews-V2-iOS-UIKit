//
//  TopHeadlinesViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation
import Combine

final class TopHeadlinesViewModel {
    // Delegate
    weak var coordinator: TopHeadlinesViewControllerDelegate?
    
    private let useCase: TopHeadlinesUseCaseProtocol
    private var categoryViewModels = [CategoryCellViewModel]()
    private var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    private var savedMediaSource = SavedSourceDTO(id: "le-monde", name: "Le Monde")
    private var isFirstLoad = true
    
    // MARK: - Bindings
    private var categoryUpdateResult = PassthroughSubject<Bool, Never>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var categoryUpdateResultPublisher: AnyPublisher<Bool, Never> {
        return categoryUpdateResult.eraseToAnyPublisher()
    }
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(useCase: TopHeadlinesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: - Category management
    func initCategories() {
        categoryViewModels = CategoryCellViewModel.getCategories()
        loadAndUpdateSourceCategoryTitle()
    }
    
    func loadAndUpdateSourceCategoryTitle() {
        print("[TopHeadlinesViewModel] Loading saved source if existing...")
        
        Task {
            let result = await useCase.loadSavedSelectedSource()
            
            switch result {
                case .success(let savedSource):
                    print("[TopHeadlinesViewModel] Loading succeeded for saved source: \(savedSource.name), ID: \(savedSource.id)")
                    self.savedMediaSource = savedSource
                case .failure(let error):
                    print("[TopHeadlinesViewModel] Loading failed, the default source will be used: \(savedMediaSource.name), ID: \(savedMediaSource.id)")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
            
            // If it fails, it will use the default one.
            self.updateSourceCategoryTitle()
            print("[TopHeadlinesViewModel] Categories: \(categoryViewModels.count)")
            self.categoryUpdateResult.send(true)
        }
    }
    
    func updateSourceCategoryTitle() {
        if let sourceCategoryViewModel = categoryViewModels.first(where: { $0.categoryId == "source" }) {
            sourceCategoryViewModel.setCategoryTitle(with: "Actualité du média \(savedMediaSource.name)")
        }
    }
    
    // MARK: - Top headlines
    func fetchTopHeadlines() {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .localCountryNews(countryCode: "fr"))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlinesWithSource() {
        Task {
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .sourceNews(name: savedMediaSource.id))
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
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    // MARK: - CollectionView and TableView logic
    // In that case, it's a unique section CollectionView
    func numberOfItemsInCollectionView() -> Int {
        return categoryViewModels.count
    }
    
    func getCategoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel? {
        let cellCount = categoryViewModels.count
        
        guard cellCount > 0, indexPath.item <= cellCount else {
            return nil
        }
        
        return categoryViewModels[indexPath.item]
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
}

// Navigation part
extension TopHeadlinesViewModel {
    func goToSourceSelectionView() {
        print("[TopHeadlinesViewModel] TopHeadlines -> Coordinator -> SourceSelection")
        coordinator?.goToSourceSelectionView()
    }
    
    func goToArticleDetailView(selectedViewModelIndex: Int) {
        print("[TopHeadlinesViewModel] TopHeadlines -> Coordinator -> ArticleDetail")
        print("ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
