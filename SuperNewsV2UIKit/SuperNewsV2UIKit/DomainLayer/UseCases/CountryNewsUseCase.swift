//
//  CountryNewsUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 07/06/2023.
//

import Foundation

/// This use case will fetch the top headlines news of a specific country from the API
final class CountryNewsUseCase: CountryNewsUseCaseProtocol {
    private let dataRepository: SuperNewsRepository
    
    init(dataRepository: SuperNewsRepository) {
        self.dataRepository = dataRepository
    }
    
    func execute(countryCode: String) async -> Result<[ArticleViewModel], SuperNewsAPIError> {
        return handleResult(with: await dataRepository.fetchTopHeadlinesNews(countryCode: countryCode, category: nil))
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
