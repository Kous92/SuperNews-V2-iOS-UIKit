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
    
    fileprivate func getApiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apiKey", ofType: "plist") else {
            print("ERREUR: Fichier apiKey.plist inexistant")
            return nil
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            print("ERREUR: Données indisponibles")
            return nil
        }
        
        return dictionary.object(forKey: "apiKey") as? String
    }
    
    private func getAuthorizationHeader() -> HTTPHeaders {
        return [.authorization(bearerToken: apiKey)]
    }
    
    init() {
        self.apiKey = getApiKey() ?? ""
        print("Initialisation avec la clé: \(apiKey)")
    }
    
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError> {
        return handleSourcesResult(with: await getRequest(endpoint: .fetchAllSources))
    }
    
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return handleSourcesResult(with: await getRequest(endpoint: .fetchSourcesWithCategory(category: category)))
    }
    
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return handleSourcesResult(with: await getRequest(endpoint: .fetchSourcesWithLanguage(language: language)))
    }
    
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        return handleSourcesResult(with: await getRequest(endpoint: .fetchSourcesWithCountry(country: country)))
    }
    
    func fetchTopHeadlinesNews(countryCode: String, category: String? = nil) async -> Result<[Article], SuperNewsAPIError> {
        return handleArticlesResult(with: await getRequest(endpoint: .fetchTopHeadlinesNews(countryCode: countryCode, category: category)))
    }
    
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[Article], SuperNewsAPIError> {
        return handleArticlesResult(with: await getRequest(endpoint: .fetchTopHeadlinesNewsWithSource(name: sourceName)))
    }
    
    func searchNewsFromEverything(with searchQuery: String, language: String = "fr", sortBy: String = "publishedAt") async -> Result<[Article], SuperNewsAPIError> {
        return handleArticlesResult(with: await getRequest(endpoint: .searchNewsFromEverything(searchQuery: searchQuery, language: language, sortBy: sortBy)))
    }
    
    private func handleSourcesResult(with result: Result<MediaSourceOutput, SuperNewsAPIError>) -> Result<[MediaSource], SuperNewsAPIError> {
        switch result {
            case .success(let data):
                return .success(data.sources)
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func handleArticlesResult(with result: Result<ArticleOutput, SuperNewsAPIError>) -> Result<[Article], SuperNewsAPIError> {
        switch result {
            case .success(let data):
                return .success(data.articles ?? [])
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func getRequest<T: Decodable>(endpoint: SuperNewsAPIEndpoint) async -> Result<T, SuperNewsAPIError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        print("URL appelée: \(url.absoluteString)")
        let request = AF.request(url, headers: getAuthorizationHeader()).validate()
        // let request = AF.request(url).validate()
        // let request = AF.request(url, headers: getAuthorizationHeader()).validate(statusCode: 200...201)

        let decodableResponse = await request.serializingDecodable(T.self).response
        
        switch decodableResponse.result {
            case .success:
                guard let data = decodableResponse.value else {
                    return .failure(.decodeError)
                }
                
                return .success(data)
            case let .failure(error):
                guard let httpResponse = decodableResponse.response else {
                    print("ERREUR: \(error)")
                    return .failure(.networkError)
                }
                
                print("Code d'échec: \(httpResponse.statusCode)")
                
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