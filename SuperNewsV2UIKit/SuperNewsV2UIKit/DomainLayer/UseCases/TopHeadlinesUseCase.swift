//
//  TopHeadlinesUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

final class TopHeadlinesUseCase: TopHeadlinesUseCaseProtocol {
    private let repository: SuperNewsRepository
    
    init(repository: SuperNewsRepository) {
        self.repository = repository
    }
    
    func execute(countryCode: String = "fr", category: String? = nil) async -> Result<[NewsCellViewModel], SuperNewsAPIError> {
        let result = await repository.fetchTopHeadlinesNews(countryCode: countryCode, category: category)
        
        switch result {
            case .success(let articles):
                // print("DTOs:\n\(articles)")
                return .success(parseViewModels(with: articles))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    func execute(source: String) async -> Result<[NewsCellViewModel], SuperNewsAPIError> {
        let result = await repository.fetchTopHeadlinesNews(sourceName: source)
        
        switch result {
            case .success(let articles):
                // print("DTOs:\n\(articles)")
                return .success(parseViewModels(with: articles))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func parseViewModels(with articles: [ArticleDTO]) -> [NewsCellViewModel] {
        var viewModels = [NewsCellViewModel]()
        articles.forEach { viewModels.append(NewsCellViewModel(imageURL: $0.imageUrl, title: $0.title, source: $0.sourceName)) }
        
        return viewModels
    }
}
