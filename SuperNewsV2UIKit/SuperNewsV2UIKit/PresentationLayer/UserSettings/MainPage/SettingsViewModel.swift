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
    
    // For resetting user settings to default settings
    private let useCase: ResetUserSettingsUseCaseProtocol
    
    // private let useCase: UserSettingsUseCaseProtocol
    private var sectionViewModels = [SettingsSectionViewModel]()
    
    // Bindings and subscriptions
    @Published var searchQuery = ""
    private var updateResult = PassthroughSubject<Bool, Never>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    init(useCase: ResetUserSettingsUseCaseProtocol) {
        self.useCase = useCase
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

extension SettingsViewModel {
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        print("[SettingsViewModel] Error to display: \(errorMessage)")
        
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func goToSettingsSelectionView(at indexPath: IndexPath) {
        let option = sectionViewModels[indexPath.row].description
        print("[SettingsViewModel] Selected option: \(option)")
        
        guard option != "reset" else {
            print("[SettingsViewModel] Resetting parameters.")
            coordinator?.showResetSettingsAlert(completion: { [weak self] reset in
                if reset {
                    self?.resetUserSettings()
                }
            })
            return
        }
        
        coordinator?.goToSettingsSelectionView(settingSection: sectionViewModels[indexPath.row].getSettingSection())
    }
    
    private func resetUserSettings() {
        Task {
            print("[SettingsViewModel] Resetting user settings to default.")
            let result = await useCase.execute()
            
            switch result {
                case .success():
                    print("[SettingsViewModel] Resetting succeeded to default settings.")
                case .failure(let error):
                    print("[SettingsViewModel] Resetting failed. ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
}
