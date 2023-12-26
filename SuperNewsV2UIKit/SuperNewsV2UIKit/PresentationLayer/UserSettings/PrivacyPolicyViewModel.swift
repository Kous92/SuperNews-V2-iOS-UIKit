//
//  PrivacyPolicyViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import Foundation
import Combine

final class PrivacyPolicyViewModel {
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
        
        Task {
            let result = await loadPrivacyPolicyUseCase.execute()
            
            switch result {
            case .success(let privacyPolicy):
                print("[PrivacyPolicyViewModel] Loading succeeded for privacy policy.")
                let headerViewModel = PrivacyHeaderViewModel(title: privacyPolicy.title, date: privacyPolicy.updateDate)
                let cellViewModels = privacyPolicy.sections.map { section in
                    PrivacyCellViewModel(subtitle: section.subtitle, description: section.content)
                }
                
                self.privacyTableViewModel = PrivacyTableViewModel(headerViewModel: headerViewModel, cellViewModels: cellViewModels)
                updateResult.send()
            case .failure(let error):
                print("[SourceSelectionViewModel] ERROR: \(String(localized: String.LocalizationValue(error.rawValue)))")
                await sendErrorMessage(with: String(localized: String.LocalizationValue(error.rawValue)))
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
