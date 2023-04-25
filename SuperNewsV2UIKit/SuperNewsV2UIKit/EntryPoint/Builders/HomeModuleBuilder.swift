//
//  HomeModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import Foundation
import UIKit

final class HomeModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool) -> UIViewController {
        self.testMode = testMode
        let homeViewController = HomeViewController()
        
        // Dependency injection
        let repository = getRepository(testMode: testMode)
        let useCase = TopHeadlinesUseCase(repository: repository)
        let homeViewModel = HomeViewModel(useCase: useCase)
        
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
