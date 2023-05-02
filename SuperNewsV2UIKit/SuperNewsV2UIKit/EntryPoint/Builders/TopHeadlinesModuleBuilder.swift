//
//  TopHeadlinesModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import Foundation
import UIKit

final class TopHeadlinesModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let homeViewController = TopHeadlinesViewController()
        
        // Dependency injection
        let repository = getRepository(testMode: testMode)
        let useCase = TopHeadlinesUseCase(repository: repository)
        let homeViewModel = HomeViewModel(useCase: useCase)
        homeViewModel.coordinator = coordinator as? HomeViewControllerDelegate
        
        // Setting delegate for passing data backwards
        if let homeCoordinator = coordinator as? HomeCoordinator {
            homeCoordinator.delegate = homeViewModel
        }
        
        // Injecting view model
        homeViewController.viewModel = homeViewModel
        
        return homeViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
}
