//
//  SuperNewsDataRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

final class SuperNewsDataRepository: SuperNewsRepository {
    
    private let apiService: SuperNewsDataAPIService?
    
    init(apiService: SuperNewsDataAPIService?) {
        self.apiService = apiService
    }
    
    func fetchAllNewsSources() async -> Result<[SourceDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchAllNewsSources() else {
            return .failure(.apiError)
        }
        
        return handleSourceResult(with: result)
    }
    
    func fetchNewsSources(category: String) async -> Result<[SourceDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchNewsSources(category: category) else {
            return .failure(.apiError)
        }
        
        return handleSourceResult(with: result)
    }
    
    func fetchNewsSources(language: String) async -> Result<[SourceDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchNewsSources(language: language) else {
            return .failure(.apiError)
        }
        
        return handleSourceResult(with: result)
    }
    
    func fetchNewsSources(country: String) async -> Result<[SourceDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchNewsSources(country: country) else {
            return .failure(.apiError)
        }
        
        return handleSourceResult(with: result)
    }
    
    func fetchTopHeadlinesNews(countryCode: String, category: String?) async -> Result<[ArticleDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchTopHeadlinesNews(countryCode: countryCode, category: category) else {
            return .failure(.apiError)
        }
        
        return handleArticleResult(with: result)
    }
    
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[ArticleDTO], SuperNewsAPIError> {
        guard let result = await apiService?.fetchTopHeadlinesNews(sourceName: sourceName) else {
            return .failure(.apiError)
        }
        
        return handleArticleResult(with: result)
    }
    
    func searchNewsFromEverything(with searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleDTO], SuperNewsAPIError> {
        guard let result = await apiService?.searchNewsFromEverything(with: searchQuery, language: language, sortBy: sortBy) else {
            return .failure(.apiError)
        }
        
        return handleArticleResult(with: result)
    }
    
    private func handleArticleResult(with result: Result<[Article], SuperNewsAPIError>) -> Result<[ArticleDTO], SuperNewsAPIError> {
        switch result {
            case .success(let articles):
                print("Articles before conversion:\n\(articles)")
                return .success(articlesToDTO(with: articles))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func handleSourceResult(with result: Result<[MediaSource], SuperNewsAPIError>) -> Result<[SourceDTO], SuperNewsAPIError> {
        switch result {
            case .success(let sources):
                return .success(sourcesToDTO(with: sources))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    /// Converts Article data objects to Article Data Transfer Object for Domain Layer
    private func articlesToDTO(with articles: [Article]) -> [ArticleDTO] {
        var dtoList = [ArticleDTO]()
        articles.forEach { dtoList.append(ArticleDTO(with: $0)) }
        
        return dtoList
    }
    
    /// Converts MediaSource data objects to Source Data Transfer Object for Domain Layer
    private func sourcesToDTO(with sources: [MediaSource]) -> [SourceDTO] {
        var dtoList = [SourceDTO]()
        sources.forEach { dtoList.append(SourceDTO(with: $0)) }
        
        return dtoList
    }
}
