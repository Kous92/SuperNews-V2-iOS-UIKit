//
//  TopHeadlinesUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

/// This use case will fetch the top headlines news from the API
final class TopHeadlinesUseCase: TopHeadlinesUseCaseProtocol {
    private let dataRepository: SuperNewsRepository
    
    init(dataRepository: SuperNewsRepository) {
        self.dataRepository = dataRepository
    }
    
    func execute(topHeadlinesOption: TopHeadlinesOption) async -> Result<[ArticleViewModel], SuperNewsAPIError> {
        switch topHeadlinesOption {
            case .sourceNews(name: let name):
                return handleResult(with: await dataRepository.fetchTopHeadlinesNews(sourceName: name))
            case .categoryNews(name: let name, countryCode: let countryCode):
                return handleResult(with: await dataRepository.fetchTopHeadlinesNews(countryCode: countryCode, category: name))
            case .localCountryNews(countryCode: let countryCode):
                return handleResult(with: await dataRepository.fetchTopHeadlinesNews(countryCode: countryCode, category: nil))
        }
    }
    
    private func handleResult(with result: Result<[ArticleDTO], SuperNewsAPIError>) -> Result<[ArticleViewModel], SuperNewsAPIError> {
        switch result {
            case .success(let articles):
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
