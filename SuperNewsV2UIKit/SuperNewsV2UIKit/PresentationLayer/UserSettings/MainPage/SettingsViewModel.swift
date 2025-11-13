//
//  SettingsViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation

@MainActor final class SettingsViewModel {
    weak var coordinator: SettingsViewControllerDelegate?
    
    // For resetting user settings to default settings
    private let resetUserSettingsUseCase: ResetUserSettingsUseCaseProtocol
    
    // private let useCase: UserSettingsUseCaseProtocol
    private var sectionViewModels = [SettingsSectionViewModel]()
    
    init(resetUserSettingsUseCase: ResetUserSettingsUseCaseProtocol) {
        self.resetUserSettingsUseCase = resetUserSettingsUseCase
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
    
    @MainActor func goToSettingsSelectionView(at indexPath: IndexPath) {
        let option = sectionViewModels[indexPath.row].description
        print("[SettingsViewModel] Selected option: \(option)")
        
        switch option {
        case "reset":
            notifyUserWithReset()
        case "privacyPolicy":
            coordinator?.goToPrivacyPolicyView()
        case "language", "country":
            coordinator?.goToSettingsSelectionView(settingSection: sectionViewModels[indexPath.row].getSettingSection())
        default:
            break
        }
    }
    
    @MainActor private func notifyUserWithReset() {
        print("[SettingsViewModel] Resetting parameters. Thread: \(Thread.currentThread)")
        coordinator?.showResetSettingsAlert(completion: { [weak self] reset in
            if reset {
                self?.resetUserSettings()
            }
        })
    }
    
    nonisolated private func resetUserSettings() {
        Task { [weak self] in
            print("[SettingsViewModel] Resetting user settings to default. Thread: \(Thread.currentThread)")
            do {
                let result = try await self?.resetUserSettingsUseCase.execute()
                print("[SettingsViewModel] Resetting succeeded to default settings.")
            } catch SuperNewsUserSettingsError.userSettingsError {
                print("[SettingsViewModel] Resetting failed. ERROR: \(SuperNewsUserSettingsError.userSettingsError.rawValue)")
                await self?.sendErrorMessage(with: SuperNewsUserSettingsError.userSettingsError.rawValue)
            }
        }
    }
}
