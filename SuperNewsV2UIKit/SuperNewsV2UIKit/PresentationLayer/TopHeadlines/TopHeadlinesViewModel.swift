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
    
    /// Category as key and country code as value. It will be useful to not fire up HTTP requests everytime to download the same existing data.
    private var fetchedData = [String: String]()
    
    // Settings
    private var savedMediaSource = SavedSourceDTO(id: "le-monde", name: "Le Monde")
    private var savedLocalCountry = CountryLanguageSettingDTO(name: "France", code: "fr", flagCode: "fr")
    private var previousSavedCountryCode = "fr"
    private var userSettingloadingCount = 0
    
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
    }
    
    func loadAndUpdateSourceCategoryTitle() {
        print("[TopHeadlinesViewModel] Loading saved source if existing...")
        userSettingloadingCount += 1
        previousSavedCountryCode = savedLocalCountry.code
        
        Task {
            let result = await useCase.loadSavedSelectedSource()
            
            switch result {
                case .success(let savedSource):
                    print("[TopHeadlinesViewModel] Loading succeeded for saved source: \(savedSource.name), ID: \(savedSource.id)")
                    self.savedMediaSource = savedSource
                case .failure(let error):
                    print("[TopHeadlinesViewModel] Loading failed, the default source will be used: \(savedMediaSource.name), ID: \(savedMediaSource.id)")
                    print("[TopHeadlinesViewModel] ERROR: \(String(localized: String.LocalizationValue(error.rawValue)))")
            }
            
            // If it fails, it will use the default one.
            self.updateSourceCategoryTitle()
            print("[TopHeadlinesViewModel] Categories: \(categoryViewModels.count)")
            self.categoryUpdateResult.send(true)
        }
    }
    
    func loadAndUpdateUserCountrySettingTitle() {
        print("[TopHeadlinesViewModel] Loading saved user country if existing...")
        
        Task {
            let result = await useCase.loadUserCountryLanguageSetting()
            
            switch result {
                case .success(let userSetting):
                    print("[TopHeadlinesViewModel] Loading succeeded for saved user country setting: \(userSetting.name), code: \(userSetting.code)")
                    self.savedLocalCountry = userSetting
                case .failure(let error):
                    print("[TopHeadlinesViewModel] Loading failed, the default source will be used: \(savedLocalCountry.name), code: \(savedLocalCountry.code)")
                    print("[TopHeadlinesViewModel] ERROR: \(String(localized: String.LocalizationValue(error.rawValue)))")
            }
            
            // If it fails, it will use the default one.
            self.updateCountryCategoryTitle()
            print("[TopHeadlinesViewModel] Categories: \(categoryViewModels.count)")
            self.categoryUpdateResult.send(true)
            self.fetchTopHeadlines()
        }
    }
    
    // Check if the user has set a different country in the setting when using the app
    func checkSavedCountry() {
        // Update country top headlines only if country setting has been changed during the use of the app
        if savedLocalCountry.code != previousSavedCountryCode {
            print("\(savedLocalCountry.code) != \(previousSavedCountryCode)")
            print("[TopHeadlinesViewModel] Top headlines will be updated for new country set: \(savedLocalCountry.name)")
            self.fetchTopHeadlines()
        }
    }
    
    private func updateSourceCategoryTitle() {
        if let sourceCategoryViewModel = categoryViewModels.first(where: { $0.categoryId == "source" }) {
            // sourceCategoryViewModel.setCategoryTitle(with: "Actualité du média \(savedMediaSource.name)")
            sourceCategoryViewModel.setCategoryTitle(with: "\(String(localized: "mediaNews")) \(savedMediaSource.name)")
        }
    }
    
    private func updateCountryCategoryTitle() {
        if let sourceCategoryViewModel = categoryViewModels.first(where: { $0.categoryId == "local" }) {
            // sourceCategoryViewModel.setCategoryTitle(with: "\(String(localized: "localNews"))Actualités locales (\(savedLocalCountry.name))")
            sourceCategoryViewModel.setCategoryTitle(with: "\(String(localized: "localNews")) (\(savedLocalCountry.name))")
        }
    }
    
    // MARK: - Top headlines
    func fetchTopHeadlines() {
        /*
        guard fetchedData["local"] != savedLocalCountry.code else {
            print("[TopHeadlinesViewModel] Top headlines local news from country code \(savedLocalCountry.code) are already downloaded.")
            return
        }
         */
        
        Task {
            fetchedData["local"] = savedLocalCountry.code
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .localCountryNews(countryCode: savedLocalCountry.code))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlinesWithSource() {
        /*
        guard fetchedData["source"] != savedMediaSource.id else {
            print("[TopHeadlinesViewModel] Top headlines news from \(savedMediaSource.name) are already downloaded.")
            return
        }
         */
        
        Task {
            fetchedData["source"] = savedMediaSource.id
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .sourceNews(name: savedMediaSource.id))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlines(with category: String) {
        /*
        guard fetchedData[category] != savedLocalCountry.code else {
            print("[TopHeadlinesViewModel] Top headlines \(category) news from country code \(savedLocalCountry.code) are already downloaded.")
            return
        }
         */
        
        Task {
            fetchedData[category] = savedLocalCountry.code
            isLoading.send(true)
            let result = await useCase.execute(topHeadlinesOption: .categoryNews(name: category, countryCode: savedLocalCountry.code))
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[ArticleViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[TopHeadlinesViewModel] Retrieved data: \(viewModels.count) articles")
                self.articleViewModels = viewModels
                await parseViewModels()
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("[TopHeadlinesViewModel] ERROR: " + String(localized: String.LocalizationValue(error.rawValue)))
                await self.sendErrorMessage(with: String(localized: String.LocalizationValue(error.rawValue)))
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
        print("[TopHeadlinesViewModel] ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
