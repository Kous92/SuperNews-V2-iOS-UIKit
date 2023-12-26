//
//  PrivacyPolicyModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import Foundation
import UIKit

final class PrivacyPolicyModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let privacyPolicyViewController = PrivacyPolicyViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let privacyPolicyFileRepository = getPrivacyPolicyFileRepository(testMode: self.testMode)
        
        // 2) Get use case instances: domain layer
        let loadPrivacyPolicyUseCase = LoadPrivacyPolicyUseCase(privacyPolicyFileRepository: privacyPolicyFileRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let privacyPolicyViewModel = PrivacyPolicyViewModel(loadPrivacyPolicyUseCase: loadPrivacyPolicyUseCase)
        
        // 4) Injecting coordinator for presentation layer
        privacyPolicyViewModel.coordinator = coordinator as? PrivacyPolicyViewControllerDelegate
        
        // 5) Injecting view model to the view
        privacyPolicyViewController.viewModel = privacyPolicyViewModel
        
        return privacyPolicyViewController
    }
    
    private func getPrivacyPolicyFileRepository(testMode: Bool) -> SuperNewsPrivacyPolicyFileRepository {
        return SuperNewsPrivacyPolicyFileRepository(localFileService: getPrivacyPolicyFileService(testMode: testMode))
    }
    
    private func getPrivacyPolicyFileService(testMode: Bool) -> SuperNewsPrivacyPolicyLocalDataFileService {
        return testMode ? SuperNewsMockPrivacyPolicyFileService(forceLoadFailure: false) : SuperNewsPrivacyPolicyJSONFileService()
    }
}
