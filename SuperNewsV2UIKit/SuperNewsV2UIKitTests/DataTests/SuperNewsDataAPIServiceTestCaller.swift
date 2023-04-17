//
//  SuperNewsDataAPIServiceTestCaller.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 15/04/2023.
//

import Foundation
@testable import SuperNewsV2UIKit

final class SuperNewsDataAPIServiceTestCaller {
    var invokedFetchNewsSources = false
    var invokedFetchNewsSourcesCount = 0
    var invokedFetchTopHeadlinesNews = false
    var invokedFetchTopHeadlinesNewsCount = 0
    var invokedSearchNewsFromEverything = false
    var invokedSearchNewsFromEverythingCount = 0
    
    func fetchAllNewsSourcesSuccess() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchAllNewsSources()
    }
    
    func fetchAllNewsSourcesFailure() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: true)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchAllNewsSources()
    }
    
    func fetchCategoryNewsSourcesSuccess() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(category: "technology")
    }
    
    func fetchCategoryNewsSourcesFailure() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(category: "business")
    }
    
    func fetchCountryNewsSourcesSuccess() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(country: "fr")
    }
    
    func fetchCountryNewsSourcesFailure() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(country: "us")
    }
    
    func fetchLanguageNewsSourcesSuccess() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(language: "en")
    }
    
    func fetchLanguageNewsSourcesFailure() async -> Result<[MediaSource], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchNewsSources = true
        invokedFetchNewsSourcesCount += 1
        
        return await networkService.fetchNewsSources(language: "fr")
    }
    
    func fetchTopHeadlinesNewsWithCountrySuccess() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews(countryCode: "fr")
    }
    
    func fetchTopHeadlinesNewsWithCountryFailure() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews()
    }
    
    func fetchTopHeadlinesNewsWithCategorySuccess() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews(category: "sports")
    }
    
    func fetchTopHeadlinesNewsWithCategoryFailure() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews()
    }
    
    func fetchTopHeadlinesNewsWithSourceSuccess() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews(sourceName: "lequipe")
    }
    
    func fetchTopHeadlinesNewsWithSourceFailure() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedFetchTopHeadlinesNews = true
        invokedFetchTopHeadlinesNewsCount += 1
        
        return await networkService.fetchTopHeadlinesNews(sourceName: "google-news-fr")
    }
    
    func searchNewsFromEverythingSuccess() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedSearchNewsFromEverything = true
        invokedSearchNewsFromEverythingCount += 1
        
        return await networkService.searchNewsFromEverything(with: "iPhone")
    }
    
    func searchNewsFromEverythingFailure() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedSearchNewsFromEverything = true
        invokedSearchNewsFromEverythingCount += 1
        
        return await networkService.searchNewsFromEverything(with: "Samsung")
    }
    
    func searchNewsFromEverythingWithLanguageSuccess() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedSearchNewsFromEverything = true
        invokedSearchNewsFromEverythingCount += 1
        
        return await networkService.searchNewsFromEverything(with: "iPhone", language: "en")
    }
    
    func searchNewsFromEverythingWithLanguageFailure() async -> Result<[Article], SuperNewsAPIError> {
        let networkService = SuperNewsMockDataAPIService(forceFetchFailure: false)
        invokedSearchNewsFromEverything = true
        invokedSearchNewsFromEverythingCount += 1
        
        return await networkService.searchNewsFromEverything(with: "iPhone", language: "es")
    }
}
