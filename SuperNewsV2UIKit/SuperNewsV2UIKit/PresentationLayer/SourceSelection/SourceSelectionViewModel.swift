//
//  SourceSelectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation
import Combine

final class SourceSelectionViewModel {
    weak var coordinator: SourceSelectionViewControllerDelegate?
    
    private let sourceSelectionUseCase: SourceSelectionUseCaseProtocol
    private let loadSelectedSourceUseCase: LoadSavedSelectedSourceUseCaseProtocol
    private let saveSelectedSourceUseCase: SaveSelectedSourceUseCaseProtocol
    
    private let categoryViewModels = CategoryCellViewModel.getSourceCategories()
    private var cellViewModels = [SourceCellViewModel]()
    private var sectionViewModels = [SourceSectionViewModel]()
    private(set) var filteredSectionViewModels = [SourceSectionViewModel]()
    
    // Settings
    private var savedMediaSource = {
        let countryCode = Locale.current.language.languageCode?.identifier == "fr" ? "fr" : "us"
        return countryCode == "fr" ? SavedSourceDTO(id: "le-monde", name: "Le Monde") : SavedSourceDTO(id: "abc-news", name: "ABC News")
    }()
    
    // Bindings and subscriptions
    @Published var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var favoriteSourceUpdateResult = PassthroughSubject<String, Never>()
    private var sortedUpdateResult = PassthroughSubject<Bool, Never>()
    private var isLoading = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var favoriteSourceUpdateResultPublisher: AnyPublisher<String, Never> {
        return favoriteSourceUpdateResult.eraseToAnyPublisher()
    }
    
    var sortedUpdateResultPublisher: AnyPublisher<Bool, Never> {
        return sortedUpdateResult.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    init(sourceSelectionUseCase: SourceSelectionUseCaseProtocol, loadSelectedSourceUseCase: LoadSavedSelectedSourceUseCaseProtocol, saveSelectedSourceUseCase: SaveSelectedSourceUseCaseProtocol) {
        self.sourceSelectionUseCase = sourceSelectionUseCase
        self.loadSelectedSourceUseCase = loadSelectedSourceUseCase
        self.saveSelectedSourceUseCase = saveSelectedSourceUseCase
        setBindings()
        fetchAllSources()
    }
    
    func setSourceOption(with optionName: String) {
        isLoading.send(true)
        sectionViewModels.removeAll()
        
        switch optionName {
            case "allSources":
                fetchAllSources()
            case "languageSources":
                setLanguageSorting()
            case "categorySources":
                setCategorySorting()
            case "countrySources":
                setCountrySorting()
            default:
                break
        }
    }
    
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.isLoading.send(true)
                self?.filterSources()
            }.store(in: &subscriptions)
    }
    
    private func fetchAllSources() {
        print("[SourceSelectionViewModel] Fetching all sources")
        
        Task {
            // Download the data only once
            let result = cellViewModels.isEmpty ? await sourceSelectionUseCase.execute() : .success(cellViewModels)
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[SourceCellViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                self.cellViewModels = viewModels
                self.sectionViewModels.append(self.parseSection(with: String(localized: "allSources"), cellViewModels: cellViewModels))
                self.filteredSectionViewModels = sectionViewModels
                print("[SourceSelectionViewModel] Retrieved data: \(self.cellViewModels.count) sources")
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("[SourceSelectionViewModel] ERROR: " + error.rawValue)
                await self.sendErrorMessage(with: error.rawValue)
                self.updateResult.send(false)
        }
    }
    
    private func parseSection(with name: String, cellViewModels: [SourceCellViewModel]) -> SourceSectionViewModel {
        return SourceSectionViewModel(sectionName: name, sourceCellViewModels: cellViewModels)
    }
    
    func saveSelectedSource(at indexPath: IndexPath) {
        guard let cellViewModel = getCellViewModel(at: indexPath) else {
            print("[SourceSelectionViewModel] ERROR when selecting the cell")
            return
        }
        
        let savedSource = SavedSourceDTO(id: cellViewModel.id, name: cellViewModel.name)
        print("[SourceSelectionViewModel] Selected source to save: \(savedSource.name), ID: \(savedSource.id)")
        
        Task {
            let result = await saveSelectedSourceUseCase.execute(with: savedSource)
            
            switch result {
                case .success():
                    print("[SourceSelectionViewModel] Saving succeeded")
                    await backToHomeView(with: savedSource.id)
                case .failure(let error):
                    print("[SourceSelectionViewModel] Saving failed. ERROR: \(error.rawValue)")
            }
        }
    }
    
    func loadSelectedSource() {
        print("[SourceSelectionViewModel] Loading saved source if existing...")
        
        Task {
            let result = await loadSelectedSourceUseCase.execute()
            
            switch result {
                case .success(let savedSource):
                    print("[SourceSelectionViewModel] Loading succeeded for saved source: \(savedSource.name), ID: \(savedSource.id)")
                    self.savedMediaSource = savedSource
                case .failure(let error):
                    print("[SourceSelectionViewModel] Loading failed, the default source will be used: \(savedMediaSource.name), ID: \(savedMediaSource.id)")
                    print("[SourceSelectionViewModel] ERROR: \(String(localized: String.LocalizationValue(error.rawValue)))")
            }
            
            // Update the view
            favoriteSourceUpdateResult.send(savedMediaSource.name)
        }
    }
    // MARK: - CollectionView and TableView logic
    func numberOfSections() -> Int {
        // A TableView must have at least one section, crash othervise
        guard filteredSectionViewModels.count > 0 else {
            return 1
        }
        
        return filteredSectionViewModels.count
    }
    
    func getSectionHeaderTitle(sectionIndex: Int) -> String? {
        // A TableView must have at least one section, crash othervise
        guard filteredSectionViewModels.count > 0 else {
            return nil
        }
        
        return filteredSectionViewModels[sectionIndex].sectionName
    }
    
    func numberOfRowsInSection(sectionIndex: Int) -> Int {
        // A TableView must have at least one section, crash othervise
        guard filteredSectionViewModels.count > 0 else {
            return 0
        }
        
        return filteredSectionViewModels[sectionIndex].sourceCellViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SourceCellViewModel? {
        let sectionCount = filteredSectionViewModels.count
        
        // A TableView must have at least one section and one element on CellViewModels list, crash othervise
        guard sectionCount > 0, indexPath.section <= sectionCount else {
            return nil
        }
        
        let cellCount = filteredSectionViewModels[indexPath.section].sourceCellViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return filteredSectionViewModels[indexPath.section].sourceCellViewModels[indexPath.row]
    }
    
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
}

extension SourceSelectionViewModel {
    private func filterSources() {
        guard !searchQuery.isEmpty else {
            filteredSectionViewModels = sectionViewModels
            updateResult.send(true)
            return
        }
        
        print("[SourceSelectionViewModel] Filtering sources list with: \(searchQuery)")
        filteredSectionViewModels.removeAll()
        sectionViewModels.forEach { sectionViewModel in
            let filteredSources = sectionViewModel.sourceCellViewModels.filter { vm in
                print("Filter: \(vm.name.lowercased()), searchQuery: \(searchQuery.lowercased())")
                
                // Not working with vm.name.lowercased().replacingOccurrences(of: "\\", with: "") to find sources with "'" due to backslash encoding on retrieved data.
                let name = String(NSString(string: vm.name.lowercased()))
                
                // Also, with UI, if we search a name with "'", it will use an other kind of apostrophe "’" leading to search confusions.
                let search = searchQuery.lowercased().replacingOccurrences(of: "’", with: "'")
                
                return name.contains(search)
            }
            
            print("Name: \(sectionViewModel.sectionName)")
            print("Cells count before filtering: \(sectionViewModel.sourceCellViewModels.count)")
            print("Cells: \(filteredSources)")
            
            // Add the section only if it contains at least one source after filtering. It will avoid crash when updating the TableView
            if filteredSources.count > 0 {
                filteredSectionViewModels.append(SourceSectionViewModel(sectionName: sectionViewModel.sectionName, sourceCellViewModels: filteredSources))
            }
        }
        
        // To avoid crash if not any cell was found after filtering.
        let cellCount = filteredSectionViewModels.reduce(0, { count, sectionViewModel in
            count + sectionViewModel.sourceCellViewModels.count
        })
        
        updateResult.send(cellCount > 0)
    }
    
    /// Sort source view models by language, alphabetical order
    private func setLanguageSorting() {
        let languageCodes = cellViewModels.map { $0.language }.removeDuplicates()
        languageCodes.forEach { code in
            sectionViewModels.append(parseSection(with: code.languageName()?.capitalized ?? "??", cellViewModels: cellViewModels.filter { $0.language == code }))
        }
        
        sortSectionViewModelsByNameAndUpdate()
    }
    
    /// Sort source view models by category, alphabetical order
    private func setCategorySorting() {
        let categories = cellViewModels.map { $0.category }.removeDuplicates()
        categories.forEach { category in
            sectionViewModels.append(parseSection(with: category.getCategoryNameFromCategoryCode(), cellViewModels: cellViewModels.filter { $0.category == category }))
        }
        
        sortSectionViewModelsByNameAndUpdate()
    }
    
    /// Sort source view models by country, alphabetical order
    private func setCountrySorting() {
        let countryCodes = cellViewModels.map { $0.country }.removeDuplicates()
        countryCodes.forEach { code in
            sectionViewModels.append(parseSection(with: code.countryName()?.capitalized ?? "??", cellViewModels: cellViewModels.filter { $0.country == code }))
        }
        
        sortSectionViewModelsByNameAndUpdate()
    }
    
    private func sortSectionViewModelsByNameAndUpdate() {
        sectionViewModels.sort { vm1, vm2 in
            return vm1.sectionName < vm2.sectionName
        }
        
        filteredSectionViewModels = sectionViewModels
        
        // To increase UX if user taps on other category with actual search filter
        guard searchQuery.isEmpty else {
            filterSources()
            return
        }
        
        sortedUpdateResult.send(filteredSectionViewModels.count > 0)
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        print("[SourceSelectionViewModel] Error to display: \(errorMessage)")
        
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    @MainActor func backToTopHeadlinesView() {
        print("[SourceSelectionViewModel] Back to Top Headlines screen, no source selected")
        coordinator?.backToHomeView()
    }
    
    @MainActor private func backToHomeView(with sourceId: String? = nil) {
        print("[SourceSelectionViewModel] Back to Top Headlines screen. Selected source: \(sourceId ?? "None")")
        coordinator?.backToHomeView()
    }
}
