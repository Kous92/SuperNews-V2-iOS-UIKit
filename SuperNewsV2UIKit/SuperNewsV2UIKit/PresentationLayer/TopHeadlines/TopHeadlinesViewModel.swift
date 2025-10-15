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
    
    // Use cases
    private let topHeadlinesUseCase: TopHeadlinesUseCaseProtocol
    private let loadSavedSelectedSourceUseCase: LoadSavedSelectedSourceUseCaseProtocol
    private let loadUserSettingsUseCase: LoadUserSettingsUseCaseProtocol
    
    // View models for views
    private var categoryViewModels = [CategoryCellViewModel]()
    private var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    /// Category as key and country code as value. It will be useful to not fire up HTTP requests everytime to download the same existing data.
    private var fetchedData = [String: String]()
    
    // Settings
    private var savedMediaSource = {
        let countryCode = Locale.current.language.languageCode?.identifier == "fr" ? "fr" : "us"
        return countryCode == "fr" ? SavedSourceDTO(id: "le-monde", name: "Le Monde") : SavedSourceDTO(id: "abc-news", name: "ABC News")
    }()
    private var savedLocalCountry = {
        let countryCode = Locale.current.language.languageCode?.identifier == "fr" ? "fr" : "us"
        return CountryLanguageSettingDTO(name: countryCode.countryName() ?? countryCode, code: countryCode, flagCode: countryCode)
    }()
    private var previousSavedCountryCode = ""
    private var previousSavedSourceID = ""
    private var isCategoryInitialized = false
    
    // MARK: - Bindings
    private var categoryUpdateResult = PassthroughSubject<(Bool, Int), Never>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var categoryUpdateResultPublisher: AnyPublisher<(Bool, Int), Never> {
        return categoryUpdateResult.eraseToAnyPublisher()
    }
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(topHeadlinesUseCase: TopHeadlinesUseCaseProtocol, loadSavedSelectedSourceUseCase: LoadSavedSelectedSourceUseCaseProtocol, loadUserSettingsUseCase: LoadUserSettingsUseCaseProtocol) {
        self.topHeadlinesUseCase = topHeadlinesUseCase
        self.loadSavedSelectedSourceUseCase = loadSavedSelectedSourceUseCase
        self.loadUserSettingsUseCase = loadUserSettingsUseCase
    }
    
    // MARK: - Category management
    func initCategories() {
        categoryViewModels = CategoryCellViewModel.getCategories()
    }
    
    func loadAndUpdateSourceCategoryTitle() {
        print("[TopHeadlinesViewModel] Loading saved source if existing...")
        
        Task {
            let result = await loadSavedSelectedSourceUseCase.execute()
            
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
            self.checkSavedSource()
        }
    }
    
    func loadAndUpdateUserCountrySettingTitle() {
        print("[TopHeadlinesViewModel] Loading saved user country if existing...")
        
        Task {
            let result = await loadUserSettingsUseCase.execute()
            
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
            self.checkSavedCountry()
        }
    }
    
    // Check if the user has set a different country in the setting when using the app
    private func checkSavedCountry()  {
        // Update country top headlines only if country setting has been changed during the use of the app or when it was the first load
        if savedLocalCountry.code != previousSavedCountryCode {
            print("\(savedLocalCountry.code) != \(previousSavedCountryCode)")
            print("[TopHeadlinesViewModel] Top headlines will be updated for new country set: \(savedLocalCountry.name)")
            self.categoryUpdateResult.send((true, 0))
            self.previousSavedCountryCode = savedLocalCountry.code
            self.fetchTopHeadlines()
        }
    }
    
    // Check if the user has set a different source in the setting when using the app
    func checkSavedSource() {
        // Update country top headlines only if country setting has been changed during the use of the app
        if savedMediaSource.id != previousSavedSourceID {
            print("\(savedMediaSource.id) != \(previousSavedSourceID)")
            print("[TopHeadlinesViewModel] Top headlines will be updated for new source set: \(savedMediaSource.name)")
            
            // No cell selection is it was the first load (-1)
            self.categoryUpdateResult.send((true, isCategoryInitialized ? 1 : 0))
            
            if isCategoryInitialized == true {
                self.fetchTopHeadlinesWithSource()
            }
            
            self.previousSavedSourceID = savedMediaSource.id
            self.isCategoryInitialized = true
        }
    }
    
    private func updateSourceCategoryTitle() {
        if let sourceCategoryViewModel = categoryViewModels.first(where: { $0.categoryId == "source" }) {
            sourceCategoryViewModel.setCategoryTitle(with: "\(String(localized: "mediaNews")) \(savedMediaSource.name)")
        }
    }
    
    private func updateCountryCategoryTitle() {
        if let sourceCategoryViewModel = categoryViewModels.first(where: { $0.categoryId == "local" }) {
            sourceCategoryViewModel.setCategoryTitle(with: "\(String(localized: "localNews")) (\(savedLocalCountry.code.countryName() ?? savedLocalCountry.name))")
        }
    }
    
    // MARK: - Top headlines
    func fetchTopHeadlines() {
        Task {
            fetchedData["local"] = savedLocalCountry.code
            isLoading.send(true)
            let result = await topHeadlinesUseCase.execute(topHeadlinesOption: .localCountryNews(countryCode: savedLocalCountry.code))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlinesWithSource() {
        Task {
            fetchedData["source"] = savedMediaSource.id
            isLoading.send(true)
            let result = await topHeadlinesUseCase.execute(topHeadlinesOption: .sourceNews(name: savedMediaSource.id))
            await handleResult(with: result)
        }
    }
    
    func fetchTopHeadlines(with category: String) {
        Task {
            fetchedData[category] = savedLocalCountry.code
            isLoading.send(true)
            let result = await topHeadlinesUseCase.execute(topHeadlinesOption: .categoryNews(name: category, countryCode: savedLocalCountry.code))
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
    @MainActor func goToSourceSelectionView() {
        print("[TopHeadlinesViewModel] TopHeadlines -> Coordinator -> SourceSelection")
        coordinator?.goToSourceSelectionView()
    }
    
    @MainActor func goToArticleDetailView(selectedViewModelIndex: Int) {
        print("[TopHeadlinesViewModel] TopHeadlines -> Coordinator -> ArticleDetail")
        print("[TopHeadlinesViewModel] ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
