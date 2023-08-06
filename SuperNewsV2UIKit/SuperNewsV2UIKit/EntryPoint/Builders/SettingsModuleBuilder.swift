//
//  SettingsModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation
import UIKit

final class SettingsModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let settingsViewController = SettingsViewController()
        
        // Dependency injection
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.coordinator = coordinator as? SettingsViewControllerDelegate
        
        // Injecting view model
        settingsViewController.viewModel = settingsViewModel
        
        return settingsViewController
    }
}
