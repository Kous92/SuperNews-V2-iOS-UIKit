//
//  SettingsViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation
import Combine

final class SettingsViewModel {
    weak var coordinator: SettingsViewControllerDelegate?
    
    // private let useCase: UserSettingsUseCaseProtocol
    private var sectionViewModels = [SettingsSectionViewModel]()
    
    // Bindings and subscriptions
    @Published var searchQuery = ""
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    init() {
        loadSettingsSections()
    }
    
    private func loadSettingsSections() {
        SettingsSection.allCases.forEach { sectionViewModels.append(SettingsSectionViewModel(with: $0)) }
    }
    
    func numberOfRows() -> Int {
        return sectionViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SettingsSectionViewModel? {
        return sectionViewModels[indexPath.row]
    }
}
