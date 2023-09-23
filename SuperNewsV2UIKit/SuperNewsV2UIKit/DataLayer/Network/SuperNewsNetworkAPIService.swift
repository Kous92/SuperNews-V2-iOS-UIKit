//
//  SuperNewsNetworkAPIService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import Alamofire

final class SuperNewsNetworkAPIService: SuperNewsDataAPIService {
    private var apiKey = ""
    private var cacheKey = ""
    private let articleCache = FileCache<[Article]>(fileName: "article_cache_data", expirationInterval: 21600) // 6 hours before expiration
    private let mediaSourceCache = FileCache<[MediaSource]>(fileName: "media_source_cache_data", expirationInterval: 86400) // 1 day before expiration
    
    fileprivate func getApiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apiKey", ofType: "plist") else {
            print("[SuperNewsNetworkAPIService] ERROR: apiKey.plist file does not exists")
            return nil
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            print("[SuperNewsNetworkAPIService] ERROR: Data not available")
            return nil
        }
        
        return dictionary.object(forKey: "apiKey") as? String
    }
    
    private func getAuthorizationHeader() -> HTTPHeaders {
        return [.authorization(bearerToken: apiKey)]
    }
    
    init() {
        self.apiKey = getApiKey() ?? ""
        print("[SuperNewsNetworkAPIService] Initializing with API Key: \(apiKey)")
        
        Task(priority: .userInitiated) {
            print("[SuperNewsNetworkAPIService] Initializing file caches")
            await articleCache.loadFromDisk()
            await mediaSourceCache.loadFromDisk()
        }
    }
    
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError> {
        return await fetchMediaSourceData(endpoint: .fetchAllSources)
    }
    
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return await fetchMediaSourceData(endpoint: .fetchSourcesWithCategory(category: category))
    }
    
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return await fetchMediaSourceData(endpoint: .fetchSourcesWithLanguage(language: language))
    }
    
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return await fetchMediaSourceData(endpoint: .fetchSourcesWithCountry(country: country))
    }
    
    func fetchTopHeadlinesNews(countryCode: String, category: String? = nil) async -> Result<[Article], SuperNewsAPIError> {
        return await fetchArticleData(endpoint: .fetchTopHeadlinesNews(countryCode: countryCode, category: category))
    }
    
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[Article], SuperNewsAPIError> {
        return await fetchArticleData(endpoint: .fetchTopHeadlinesNewsWithSource(name: sourceName))
    }
    
    func searchNewsFromEverything(with searchQuery: String, language: String = "fr", sortBy: String = "publishedAt") async -> Result<[Article], SuperNewsAPIError> {
        // Required to avoid any error when searching with some special characters
        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
        return await fetchArticleData(endpoint: .searchNewsFromEverything(searchQuery: encodedQuery, language: language, sortBy: sortBy))
    }
    
    /// It fetches the data with caching option. If existing data was already downloaded (and not expired), the data will be retrieved from cache.
    private func fetchArticleData(endpoint: SuperNewsAPIEndpoint) async -> Result<[Article], SuperNewsAPIError> {
        cacheKey = endpoint.path
        print("[SuperNewsNetworkAPIService] Checking cached data for key: \(cacheKey)")
        
        if let articles = await articleCache.value(key: cacheKey) {
            print("[SuperNewsNetworkAPIService] Cached data found, \(articles.count) articles available. Skipping download process.")
            return .success(articles)
        }
        
        print("[SuperNewsNetworkAPIService] No data in cache for \(cacheKey)")
        
        return await handleArticlesResult(with: await getRequest(endpoint: endpoint))
    }
    
    /// It fetches the data with caching option. If existing data was already downloaded (and not expired), the data will be retrieved from cache.
    private func fetchMediaSourceData(endpoint: SuperNewsAPIEndpoint) async -> Result<[MediaSource], SuperNewsAPIError> {
        cacheKey = endpoint.path
        print("[SuperNewsNetworkAPIService] Checking cached data for key: \(cacheKey)")
        
        if let sources = await mediaSourceCache.value(key: cacheKey) {
            print("[SuperNewsNetworkAPIService] Cached data found, \(sources.count) sources available. Skipping download process.")
            return .success(sources)
        }
        
        print("[SuperNewsNetworkAPIService] No data in cache for \(cacheKey)")
        
        return await handleSourcesResult(with: await getRequest(endpoint: endpoint))
    }
    
    private func handleSourcesResult(with result: Result<MediaSourceOutput, SuperNewsAPIError>) async -> Result<[MediaSource], SuperNewsAPIError> {
        switch result {
            case .success(let data):print("[SuperNewsNetworkAPIService] Saving \(data.sources.count) downloaded sources to local cache, key: \(cacheKey)")
                await mediaSourceCache.setValue(data.sources, key: cacheKey)
                await mediaSourceCache.saveToDisk()
                
                return .success(data.sources)
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func handleArticlesResult(with result: Result<ArticleOutput, SuperNewsAPIError>) async -> Result<[Article], SuperNewsAPIError> {
        switch result {
            case .success(let data):
                print("[SuperNewsNetworkAPIService] Saving \(data.articles?.count ?? 0) downloaded articles to local cache, key: \(cacheKey)")
                await articleCache.setValue(data.articles ?? [], key: cacheKey)
                await articleCache.saveToDisk()
                
                return .success(data.articles ?? [])
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func getRequest<T: Decodable>(endpoint: SuperNewsAPIEndpoint) async -> Result<T, SuperNewsAPIError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        print("[SuperNewsNetworkAPIService] Called URL: \(url.absoluteString), downloading data...")
        let request = AF.request(url, headers: getAuthorizationHeader()).validate()
        let decodableResponse = await request.serializingDecodable(T.self).response
        
        switch decodableResponse.result {
            case .success:
                guard let data = decodableResponse.value else {
                    return .failure(.decodeError)
                }
                
                return .success(data)
            case let .failure(error):
                guard let httpResponse = decodableResponse.response else {
                    print("[SuperNewsNetworkAPIService] ERROR: \(error)")
                    return .failure(.networkError)
                }
                
                print("[SuperNewsNetworkAPIService] Failure code: \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                    case 400:
                        return .failure(.parametersMissing)
                    case 401:
                        return .failure(.invalidApiKey)
                    case 404:
                        return .failure(.notFound)
                    case 429:
                        return .failure(.tooManyRequests)
                    case 500:
                        return .failure(.serverError)
                    default:
                        return .failure(.decodeError)
                }
        }
    }
}
