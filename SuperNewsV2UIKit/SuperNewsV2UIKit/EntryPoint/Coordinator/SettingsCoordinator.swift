//
//  SettingsCoordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation
import UIKit

// We respect the 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
protocol SettingsViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
    func goToSettingsSelectionView(settingSection: SettingsSection)
    func goToPrivacyPolicyView()
    func showResetSettingsAlert(completion: @escaping (Bool) -> ())
}

final class SettingsCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[SettingsCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[SettingsCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[SettingsCoordinator] Instantiating SettingsViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let settingsViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[MapCoordinator] Settings view ready.")
        navigationController.pushViewController(settingsViewController, animated: false)
        
        return navigationController
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func displayErrorAlert(with errorMessage: String) {
        print("[SettingsCoordinator] Displaying error alert.")
        let localizedErrorMessage = String(localized: String.LocalizationValue(errorMessage))
        let alert = UIAlertController(title: String(localized: "error"), message: localizedErrorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showResetSettingsAlert(completion: @escaping (Bool) -> ()) {
        print("[SettingsCoordinator] Displaying reset settings alert.")
        
        let alert = UIAlertController(title: String(localized: "warning"), message: String(localized: "resetSettingsAlertMessage"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: String(localized: "yes"), style: .default, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: String(localized: "no"), style: .destructive, handler: { _ in
            completion(false)
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func goToSettingsSelectionView(settingSection: SettingsSection) {
        // Transition is separated here into a child coordinator.
        print("[SettingsCoordinator] Setting child coordinator: SettingsSelectionCoordinator.")
        let settingsSelectionCoordinator = SettingsSelectionCoordinator(navigationController: navigationController, builder: SettingsSelectionModuleBuilder(settingSection: settingSection))
        
        // Adding link to the parent with self, be careful to retain cycle
        settingsSelectionCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: settingsSelectionCoordinator)
        
        // Transition from settings screen to settings selection screen
        print("[SettingsCoordinator] Go to SettingsSelectionViewController.")
        settingsSelectionCoordinator.start()
    }
    
    func goToPrivacyPolicyView() {
        // Transition is separated here into a child coordinator.
        print("[SettingsCoordinator] Setting child coordinator: PrivacyPolicyCoordinator.")
        let privacyPolicyCoordinator = PrivacyPolicyCoordinator(navigationController: navigationController, builder: PrivacyPolicyModuleBuilder())
        
        // Adding link to the parent with self, be careful to retain cycle
        privacyPolicyCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: privacyPolicyCoordinator)
        
        // Transition from settings screen to privacy policy screen
        print("[SettingsCoordinator] Go to PrivacyPolicyViewController.")
        privacyPolicyCoordinator.start()
    }
    
    private func resetUserSettings() {
        print("[SettingsCoordinator] Resetting user parameters.")
        // Resetting to default parameters
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode saved source
            let languageData = try encoder.encode(CountryLanguageSetting(name: "Français", code: "fr", flagCode: "fr"))
            let countryData = try encoder.encode(CountryLanguageSetting(name: "France", code: "fr", flagCode: "fr"))

            // Write/Set Data
            UserDefaults.standard.set(languageData, forKey: "language")
            UserDefaults.standard.set(countryData, forKey: "country")
            
            print("[SettingsCoordinator] Resetting succeeded.")
        } catch {
            print("[SettingsCoordinator] Resetting failed.")
        }
    }
}
