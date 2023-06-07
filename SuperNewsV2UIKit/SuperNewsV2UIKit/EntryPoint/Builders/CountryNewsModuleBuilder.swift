//
//  CountryNewsModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 07/06/2023.
//

import UIKit

final class CountryNewsModuleBuilder: ModuleBuilder {
    private var testMode = false
    private let countryCode: String
    
    init(countryCode: String) {
        self.countryCode = countryCode
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let countryNewsViewController = CountryNewsViewController()
        
        // Dependency injection
        let dataRepository = getRepository(testMode: testMode)
        let useCase = CountryNewsUseCase(dataRepository: dataRepository)
        let countryNewsViewModel = CountryNewsViewModel(countryCode: countryCode, useCase: useCase)
        countryNewsViewModel.coordinator = coordinator as? CountryNewsViewControllerDelegate
        
        // Injecting view model
        countryNewsViewController.viewModel = countryNewsViewModel
        
        return countryNewsViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
}
