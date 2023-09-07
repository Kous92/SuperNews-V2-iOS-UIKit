//
//  SearchUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/05/2023.
//

import Foundation

final class SearchUseCase: SearchUseCaseProtocol {
    private let dataRepository: SuperNewsRepository
    private let settingsRepository: SuperNewsSourceSettingsRepository
    
    init(dataRepository: SuperNewsRepository, settingsRepository: SuperNewsSourceSettingsRepository) {
        self.dataRepository = dataRepository
        self.settingsRepository = settingsRepository
    }
    
    func execute(searchQuery: String, language: String, sortBy: String = "publishedAt") async -> Result<[ArticleViewModel], SuperNewsAPIError> {
        return handleResult(with: await dataRepository.searchNewsFromEverything(with: searchQuery, language: language, sortBy: sortBy))
    }
    
    private func handleResult(with result: Result<[ArticleDTO], SuperNewsAPIError>) -> Result<[ArticleViewModel], SuperNewsAPIError> {
        switch result {
            case .success(let articles):
                // print("DTOs:\n\(articles)")
                return .success(parseViewModels(with: articles))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func parseViewModels(with articles: [ArticleDTO]) -> [ArticleViewModel] {
        var viewModels = [ArticleViewModel]()
        articles.forEach { viewModels.append(ArticleViewModel(with: $0)) }
        
        return viewModels
    }
}
