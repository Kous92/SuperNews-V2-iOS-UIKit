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
    
    // Use cases
    private let searchUseCase: SearchUseCaseProtocol
    private let loadUserSettingsUseCase: LoadUserSettingsUseCase
    
    // View models for views
    private var cellViewModels = [NewsCellViewModel]()
    private var articleViewModels = [ArticleViewModel]()
    
    // Settings
    private var savedLocalLanguage = {
        let languageCode = Locale.current.languageCode == "fr" ? "fr" : "en"
        
        return CountryLanguageSettingDTO(name: languageCode.languageName() ?? languageCode, code: languageCode, flagCode: languageCode)
    }()
    
    // MARK: - Bindings and subscriptions
    @Published var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    private var languageSetting = PassthroughSubject<String, Never>()
    private var isEmpty = PassthroughSubject<Void, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var isEmptyPublisher: AnyPublisher<Void, Never> {
        return isEmpty.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    var languageSettingPublisher: AnyPublisher<String, Never> {
        return languageSetting.eraseToAnyPublisher()
    }
    
    init(searchUseCase: SearchUseCaseProtocol, loadUserSettingsUseCase: LoadUserSettingsUseCase) {
        self.searchUseCase = searchUseCase
        self.loadUserSettingsUseCase = loadUserSettingsUseCase
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
    
    func loadAndUpdateUserLanguageSettingTitle() {
        print("[SearchViewModel] Loading saved user language if existing...")
        
        Task {
            let result = await loadUserSettingsUseCase.execute()
            
            // If it fails, it will use the default one.
            switch result {
                case .success(let userSetting):
                    print("[SearchViewModel] Loading succeeded for saved user language setting: \(userSetting.name), code: \(userSetting.code)")
                    self.savedLocalLanguage = userSetting
                case .failure(let error):
                    print("[SearchViewModel] Loading failed, the default language will be used: \(savedLocalLanguage.name), code: \(savedLocalLanguage.code)")
                    print("[SearchViewModel] ERROR: \(error.rawValue)")
            }
            
            self.languageSetting.send(savedLocalLanguage.code.languageName() ?? savedLocalLanguage.name)
        }
    }
    
    private func fetchNewsWithQuery() {
        // Empty content
        guard !searchQuery.isEmpty else {
            print("[SearchViewModel] Nothing to search, ignoring fetching data from network.")
            isEmpty.send()
            return
        }
        
        Task {
            isLoading.send(true)
            let result = await searchUseCase.execute(searchQuery: searchQuery, language: savedLocalLanguage.code, sortBy: "publishedAt")
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[ArticleViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                print("[SearchViewModel] Downloaded data: \(viewModels.count) articles")
                self.articleViewModels = viewModels
                await parseViewModels()
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("[SearchViewModel] ERROR: " + error.rawValue)
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
        print("[SearchViewModel] ViewModel to use: \(articleViewModels[selectedViewModelIndex])")
        coordinator?.goToDetailArticleView(with: articleViewModels[selectedViewModelIndex])
    }
}
