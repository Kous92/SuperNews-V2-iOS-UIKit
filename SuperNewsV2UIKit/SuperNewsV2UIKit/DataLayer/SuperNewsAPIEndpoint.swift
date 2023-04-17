//
//  SuperNewsAPIEndpoint.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation

enum SuperNewsAPIEndpoint {
    case fetchAllSources
    case fetchSourcesWithCategory(category: String)
    case fetchSourcesWithLanguage(language: String)
    case fetchSourcesWithCountry(country: String)
    case fetchTopHeadlinesNews(countryCode: String, category: String?)
    case fetchTopHeadlinesNewsWithSource(name: String)
    case searchNewsFromEverything(searchQuery: String, language: String, sortBy: String)
    
    var baseURL: String {
        return "https://newsapi.org/v2/"
    }
    
    var path: String {
        switch self {
            case .fetchAllSources:
                return "sources"
            case .fetchSourcesWithCategory(category: let category):
                return "sources?category=\(category)"
            case .fetchSourcesWithLanguage(language: let language):
                return "sources?language=\(language)"
            case .fetchSourcesWithCountry(country: let country):
                return "sources?country=\(country)"
            case .fetchTopHeadlinesNews(countryCode: let countryCode, category: let category):
                var urlPath = "top-headlines?country=\(countryCode)"
                
                if let category {
                    urlPath += "&category=\(category)"
                }
                
                return urlPath
            case .fetchTopHeadlinesNewsWithSource(name: let sourceName):
                return "top-headlines?sources=\(sourceName)"
            case .searchNewsFromEverything(searchQuery: let searchQuery, language: let language, sortBy: let sortBy):
                return "everything?q=\(searchQuery)&language=\(language)&sortBy=\(sortBy)"
        }
    }
}
