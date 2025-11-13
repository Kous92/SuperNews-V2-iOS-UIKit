//
//  PrivacyPolicyViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import Foundation
import Combine

@MainActor final class PrivacyPolicyViewModel {
    weak var coordinator: PrivacyPolicyViewControllerDelegate?
    
    // Use case
    private let loadPrivacyPolicyUseCase: LoadPrivacyPolicyUseCaseProtocol
    private var privacyTableViewModel: PrivacyTableViewModel
    
    // Bindings
    private var updateResult = PassthroughSubject<Void, Never>()
    var updateResultPublisher: AnyPublisher<Void, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    init(loadPrivacyPolicyUseCase: LoadPrivacyPolicyUseCaseProtocol) {
        self.loadPrivacyPolicyUseCase = loadPrivacyPolicyUseCase
        self.privacyTableViewModel = PrivacyTableViewModel(headerViewModel: PrivacyHeaderViewModel(title: "", date: ""), cellViewModels: [])
    }
    
    func loadPrivacyPolicy() {
        print("[PrivacyPolicyViewModel] Loading privacy policy with \(getLocale()) language...")
        
        Task { [weak self] in
            do {
                let privacyPolicy = try await self?.loadPrivacyPolicyUseCase.execute()
                print("[PrivacyPolicyViewModel] Loading succeeded for privacy policy.")
                let headerViewModel = PrivacyHeaderViewModel(title: privacyPolicy?.title ?? "Privacy policy", date: privacyPolicy?.updateDate ?? "26/12/2023")
                let cellViewModels = privacyPolicy?.sections.compactMap { section in
                    PrivacyCellViewModel(subtitle: section.subtitle, description: section.content)
                }
                
                self?.privacyTableViewModel = PrivacyTableViewModel(headerViewModel: headerViewModel, cellViewModels: cellViewModels ?? [])
                self?.updateResult.send()
            } catch SuperNewsLocalFileError.localFileError {
                print("[SourceSelectionViewModel] ERROR: \(SuperNewsLocalFileError.localFileError.rawValue)")
                self?.sendErrorMessage(with: SuperNewsLocalFileError.localFileError.rawValue)
            }
        }
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
}

extension PrivacyPolicyViewModel {
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        // Every section + header
        return privacyTableViewModel.cellViewModels.count + 1
    }
    
    // Header + sections
    func getCellViewModel() -> PrivacyTableViewModel? {
        return privacyTableViewModel
    }
    
    func getCellIdentifier(at indexPath: IndexPath) -> PrivacyCellIdentifier {
        return indexPath.row == 0 ? .header : .content
    }
}
