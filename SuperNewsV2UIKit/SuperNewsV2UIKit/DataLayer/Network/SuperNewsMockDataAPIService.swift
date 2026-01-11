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
        print("[SuperNewsMockDataAPIService] Starting")
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
    
    private func getMediaSourceData(with fileName: String) throws -> [MediaSource] {
        guard let fileURL = getFilePath(name: fileName) else {
            throw SuperNewsAPIError.invalidURL
        }
        
        let output: MediaSourceOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(MediaSourceOutput.self, from: data)
            
            if let mediaSources = output?.sources {
                return mediaSources
            } else {
                print("Data decoding has failed.")
                throw SuperNewsAPIError.apiError
            }
        } catch {
            print("An error has occured: \(error)")
            throw SuperNewsAPIError.apiError
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
    
    private func getArticles(with fileName: String) throws -> [Article] {
        guard let fileURL = getFilePath(name: fileName) else {
            throw SuperNewsAPIError.invalidURL
        }
        
        let output: ArticleOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(ArticleOutput.self, from: data)
            
            if let articles = output?.articles {
                return articles
            } else {
                print("Data decoding has failed.")
                throw SuperNewsAPIError.decodeError
            }
        } catch {
            print("An error has occured: \(error)")
            throw SuperNewsAPIError.apiError
        }
    }
    
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError> {
        guard forceFetchFailure == false else {
            return .failure(.apiError)
        }
        
        return getMediaSourceData(with: "AllSourcesMockData")
    }
    
    func fetchAllNewsSources() async throws -> [MediaSource] {
        guard forceFetchFailure == false else {
            throw SuperNewsAPIError.apiError
        }
        
        return try getMediaSourceData(with: "AllSourcesMockData")
    }
    
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return category == "technology" ? getMediaSourceData(with: "TechnologySourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchNewsSources(category: String) async throws -> [MediaSource] {
        guard category == "technology" else {
            throw SuperNewsAPIError.invalidURL
        }
        
        return try getMediaSourceData(with: "TechnologySourcesMockData")
        
    }
    
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return language == "en" ? getMediaSourceData(with: "EnglishSourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchNewsSources(language: String) async throws -> [MediaSource] {
        guard language == "en" else {
            throw SuperNewsAPIError.invalidURL
        }
        
        return try getMediaSourceData(with: "EnglishSourcesMockData")
    }
    
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return country == "fr" ? getMediaSourceData(with: "FranceSourcesMockData") : .failure(.invalidURL)
    }
    
    func fetchNewsSources(country: String) async throws -> [MediaSource] {
        guard country == "fr" else {
            throw SuperNewsAPIError.invalidURL
        }
        
        return try getMediaSourceData(with: "FranceSourcesMockData")
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
        
        return (countryCode == "fr" || countryCode == "us") ? getArticles(with: "FrenchTopHeadlinesMockData") : .failure(.invalidURL)
    }
    
    func fetchTopHeadlinesNews(countryCode: String = "", category: String? = nil) async throws -> [Article] {
        if let category {
            switch category {
                case "business":
                    return try getArticles(with: "BusinessTopHeadlinesMockData")
                case "entertainment":
                    return try getArticles(with: "EntertainmentTopHeadlinesMockData")
                case "general":
                    return try getArticles(with: "GeneralTopHeadlinesMockData")
                case "science":
                    return try getArticles(with: "ScienceTopHeadlinesMockData")
                case "health":
                    return try getArticles(with: "HealthTopHeadlinesMockData")
                case "sports":
                    return try getArticles(with: "SportsTopHeadlinesMockData")
                case "technology":
                    return try getArticles(with: "TechnologyTopHeadlinesMockData")
                default:
                    throw SuperNewsAPIError.invalidURL
            }
        }
        
        guard (countryCode == "fr" || countryCode == "us") else {
            throw SuperNewsAPIError.invalidURL
        }
        
        return try getArticles(with: "FrenchTopHeadlinesMockData")
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
