//
//  SettingsSelectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation
import Combine

final class SettingsSelectionViewModel {
    weak var coordinator: SettingsSelectionViewControllerDelegate?
    
    private let optionCode: String
    private let useCase: UserSettingsUseCaseProtocol
    // private var sectionViewModels = [SettingsSectionViewModel]()
    
    // MARK: - Binding
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    init(countryCode: String, useCase: UserSettingsUseCaseProtocol) {
        self.optionCode = countryCode
        self.useCase = useCase
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return 0
        // return cellViewModels.count
    }
}

// Navigation part
extension SettingsSelectionViewModel {
    func backToPreviousScreen() {
        coordinator?.backToPreviousScreen()
    }
}
