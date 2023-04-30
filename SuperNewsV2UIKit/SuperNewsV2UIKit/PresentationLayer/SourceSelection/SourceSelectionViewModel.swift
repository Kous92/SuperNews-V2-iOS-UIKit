//
//  SourceSelectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation
import Combine

final class SourceSelectionViewModel {
    // weak var coordinator: HomeViewControllerDelegate?
    private let useCase: SourceSelectionUseCaseProtocol
    private(set) var cellViewModels = [SourceCellViewModel]()
    private(set) var sectionViewModels = [SourceSectionViewModel]() {
        didSet {
            sections = sectionViewModels.count
            print("Sections = \(sections)")
        }
    }
    
    var sections = 0
    
    // Bindings
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
    }
    
    func setSourceOption(with optionName: String) {
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
    
    func fetchAllSources() {
        guard cellViewModels.isEmpty else {
            return
        }
        
        Task {
            isLoading.send(true)
            let result = await useCase.execute()
            await handleResult(with: result)
        }
    }
    
    func setLanguageSorting() {
        sectionViewModels.removeAll()
        let languageCodes = cellViewModels.map { $0.language }.removeDuplicates()
        print(languageCodes)
        
        languageCodes.forEach { code in
            sectionViewModels.append(parseSection(with: code.languageName()?.capitalized ?? "??", cellViewModels: cellViewModels.filter { $0.language == code }))
        }
        
        sectionViewModels.sort { vm1, vm2 in
            return vm1.sectionName < vm2.sectionName
        }
        
        print("Sections langues:")
        sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
        updateResult.send(true)
    }
    
    func setCategorySorting() {
        sectionViewModels.removeAll()
        let categories = cellViewModels.map { $0.category }.removeDuplicates()
        print(categories)
        
        categories.forEach { category in
            sectionViewModels.append(parseSection(with: category.getCategoryNameFromCategoryCode(), cellViewModels: cellViewModels.filter { $0.category == category }))
        }
        
        sectionViewModels.sort { vm1, vm2 in
            return vm1.sectionName < vm2.sectionName
        }
        
        print("Sections catégories:")
        sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
        updateResult.send(true)
    }
    
    func setCountrySorting() {
        sectionViewModels.removeAll()
        let countryCodes = cellViewModels.map { $0.country }.removeDuplicates()
        
        countryCodes.forEach { code in
            sectionViewModels.append(parseSection(with: code.countryName()?.capitalized ?? "??", cellViewModels: cellViewModels.filter { $0.country == code }))
        }
        
        sectionViewModels.sort { vm1, vm2 in
            return vm1.sectionName < vm2.sectionName
        }
        
        // print(countries)
        print("Sections pays:")
        sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
        updateResult.send(true)
    }
    
    private func handleResult(with result: Result<[SourceCellViewModel], SuperNewsAPIError>) async {
        switch result {
            case .success(let viewModels):
                self.cellViewModels = viewModels
                sectionViewModels.removeAll()
                self.sectionViewModels.append(self.parseSection(with: "Toutes les sources", cellViewModels: cellViewModels))
                print("[SourceSelectionViewModel] Données récupérées: \(self.cellViewModels.count) sources")
                print("Sections pays:")
                
                sectionViewModels.forEach { print("\($0.sourceCellViewModels.count) sources \($0.sectionName):\n\($0.sourceCellViewModels)\n") }
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
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        print("Error to display: \(errorMessage)")
        // coordinator?.displayErrorAlert(with: errorMessage)
    }
}
