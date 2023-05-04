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
    
    private let useCase: SourceSelectionUseCaseProtocol
    private var cellViewModels = [SourceCellViewModel]()
    private var sectionViewModels = [SourceSectionViewModel]()
    private(set) var filteredSectionViewModels = [SourceSectionViewModel]()
    
    // Bindings and subscriptions
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
    
    init(useCase: SourceSelectionUseCaseProtocol) {
        self.useCase = useCase
        setBindings()
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
        Task {
            // Download the data only once
            let result = cellViewModels.isEmpty ? await useCase.execute() : .success(cellViewModels)
            await handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<[SourceCellViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                self.cellViewModels = viewModels
                self.sectionViewModels.append(self.parseSection(with: "Toutes les sources", cellViewModels: cellViewModels))
                self.filteredSectionViewModels = sectionViewModels
                print("[SourceSelectionViewModel] Données récupérées: \(self.cellViewModels.count) sources")
                // sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
                self.updateResult.send(viewModels.count > 0)
            case .failure(let error):
                print("ERREUR: " + error.rawValue)
                await self.sendErrorMessage(with: error.rawValue)
                self.updateResult.send(false)
        }
    }
    
    private func parseSection(with name: String, cellViewModels: [SourceCellViewModel]) -> SourceSectionViewModel {
        return SourceSectionViewModel(sectionName: name, sourceCellViewModels: cellViewModels)
    }
    
    // MARK: TableView logic
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
}

extension SourceSelectionViewModel {
    private func filterSources() {
        guard !searchQuery.isEmpty else {
            filteredSectionViewModels = sectionViewModels
            updateResult.send(true)
            return
        }
        
        
        print("Filtering sources list with: \(searchQuery)")
        filteredSectionViewModels.removeAll()
        sectionViewModels.forEach { sectionViewModel in
            let filteredSources = sectionViewModel.sourceCellViewModels.filter { vm in
                print("Filter: \(vm.name.lowercased())")
                
                return vm.name.lowercased().contains(searchQuery.lowercased())
            }
            
            
            print("Name: \(sectionViewModel.sectionName)")
            print("Cells count before filtering: \(sectionViewModel.sourceCellViewModels.count)")
            print("Cells: \(filteredSources)")
            filteredSectionViewModels.append(SourceSectionViewModel(sectionName: sectionViewModel.sectionName, sourceCellViewModels: filteredSources))
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
        updateResult.send(filteredSectionViewModels.count > 0)
        // print("Sections:")
        // sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        print("Error to display: \(errorMessage)")
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func backToHomeView() {
        print("Selected source: None")
        coordinator?.backToHomeView(with: nil)
    }
    
    @MainActor private func backToHomeView(with sourceId: String? = nil) {
        print("Selected source: \(sourceId ?? "None")")
        coordinator?.backToHomeView(with: sourceId)
    }
    
    func saveSelectedSource(at indexPath: IndexPath) {
        guard let cellViewModel = getCellViewModel(at: indexPath) else {
            print("ERROR when selecting the cell")
            return
        }
        
        let savedSource = SavedSourceDTO(id: cellViewModel.id, name: cellViewModel.name)
        print("Selected source: \(savedSource.name), ID: \(savedSource.id)")
        
        Task {
            let result = await useCase.saveSelectedSource(with: savedSource)
            
            switch result {
                case .success():
                    print("Save succeeded")
                    await backToHomeView(with: savedSource.id)
                case .failure(let error):
                    print("Saving failed. ERROR: \(error.rawValue)")
            }
        }
    }
}
