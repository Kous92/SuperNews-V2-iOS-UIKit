//
//  SuperNewsMockDataAPIService.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 15/04/2023.
//

import Foundation

/// Mock data service for unit tests and live preview mode
final class SuperNewsMockDataAPIService: SuperNewsDataAPIService {
    private let forceFetchFailure: Bool
    
    init(forceFetchFailure: Bool) {
        print("Initialisation mock data")
        self.forceFetchFailure = forceFetchFailure
    }
    
    private func getFilePath(name: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("The required file \(name).json is not available, cannot test decoding data.")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        
        return nil
    }
    
    private func getMediaSourceData(with fileName: String) -> Result<[MediaSource], SuperNewsAPIError> {
        guard let fileURL = getFilePath(name: fileName) else {
            return .failure(.invalidURL)
        }
        
        let output: MediaSourceOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(MediaSourceOutput.self, from: data)
            
            if let mediaSources = output?.sources {
                return .success(mediaSources)
            } else {
                print("Data decoding has failed.")
                return .failure(.apiError)
            }
        } catch {
            print("An error has occured: \(error)")
            return .failure(.apiError)
        }
    }
    
    private func getArticles(with fileName: String) -> Result<[Article], SuperNewsAPIError> {
        guard let fileURL = getFilePath(name: fileName) else {
            return .failure(.invalidURL)
        }
        
        let output: ArticleOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(ArticleOutput.self, from: data)
            
            if let articles = output?.articles {
                return .success(articles)
            } else {
                print("Data decoding has failed.")
                return .failure(.decodeError)
            }
        } catch {
            print("An error has occured: \(error)")
            return .failure(.apiError)
        }
    }
    
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError> {
        guard forceFetchFailure == false else {
            return .failure(.apiError)
        }
        
        return getMediaSourceData(with: "AllSourcesMockData")
    }
    
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return category == "technology" ? getMediaSourceData(with: "TechnologySourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return language == "en" ? getMediaSourceData(with: "EnglishSourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return country == "fr" ? getMediaSourceData(with: "FranceSourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchTopHeadlinesNews(countryCode: String = "", category: String? = nil) async -> Result<[Article], SuperNewsAPIError> {
        if let category {
            switch category {
                case "business":
                    return getArticles(with: "BusinessTopHeadlinesMockData")
                case "entertainment":
                    return getArticles(with: "EntertainmentTopHeadlinesMockData")
                case "general":
                    return getArticles(with: "GeneralTopHeadlinesMockData")
                case "science":
                    return getArticles(with: "ScienceTopHeadlinesMockData")
                case "health":
                    return getArticles(with: "HealthTopHeadlinesMockData")
                case "sports":
                    return getArticles(with: "SportsTopHeadlinesMockData")
                case "technology":
                    return getArticles(with: "TechnologyTopHeadlinesMockData")
                default:
                    return .failure(.invalidURL)
            }
        }
        
        return countryCode == "fr" ? getArticles(with: "FrenchTopHeadlinesMockData") : .failure(.invalidURL)
    }
    
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[Article], SuperNewsAPIError> {
        return sourceName == "le-monde" ? getArticles(with: "SourcesTopHeadlinesMockData") : .failure(.invalidURL)
    }
    
    func searchNewsFromEverything(with searchQuery: String, language: String = "fr", sortBy: String = "publishedAt") async -> Result<[Article], SuperNewsAPIError> {
        
        guard searchQuery == "iPhone" else {
            return .failure(.apiError)
        }
        
        if language == "fr" {
            return getArticles(with: "EverythingiPhoneFrenchNewsMockData")
        } else if language == "en" {
            return getArticles(with: "EverythingArticleOutputMockData")
        } else {
            return .failure(.invalidURL)
        }
    }
}
