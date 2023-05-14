//
//  ArticleDetailModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import Foundation
import UIKit

final class ArticleDetailModuleBuilder: ModuleBuilder {
    private var testMode = false
    private let articleViewModel: ArticleViewModel
    
    init(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.configure(with: articleViewModel)
        /*
        // Dependency injection
        let dataRepository = getRepository(testMode: testMode)
        let settingsRepository = getSettingsRepository(testMode: testMode)
        let useCase = TopHeadlinesUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository)
        let topHeadlinesViewModel = TopHeadlinesViewModel(useCase: useCase)
        topHeadlinesViewModel.coordinator = coordinator as? TopHeadlinesViewControllerDelegate
        
        // Injecting view model
        topHeadlinesViewController.viewModel = topHeadlinesViewModel
         */
        
        return articleDetailViewController
    }
    
    private func getRepository(testMode: Bool) -> SuperNewsRepository {
        return SuperNewsDataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getSettingsRepository(testMode: Bool) -> SuperNewsSettingsRepository {
        return SuperNewsUserDefaultsRepository(settingsService: getSettingsService(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> SuperNewsDataAPIService {
        return testMode ? SuperNewsMockDataAPIService(forceFetchFailure: false) : SuperNewsNetworkAPIService()
    }
    
    private func getSettingsService(testMode: Bool) -> SuperNewsLocalSettings {
        return testMode ? SuperNewsMockLocalSettings() : SuperNewsUserDefaultsLocalSettings()
    }
}
