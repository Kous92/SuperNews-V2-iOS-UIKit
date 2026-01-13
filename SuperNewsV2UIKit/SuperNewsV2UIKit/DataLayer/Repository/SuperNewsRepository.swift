//
//  SuperNewsRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

/// The link between app layer (domain) and data layer of SuperNews app Clean Architecture. This class follows the Repository design pattern to provide an abstraction of data part, as interface to retrieve data.
protocol SuperNewsRepository: AnyObject, Sendable {
    // Network and local database part
    // func fetchAllNewsSources() async -> Result<[SourceDTO], SuperNewsAPIError>
    func fetchAllNewsSources() async throws -> [SourceDTO]
    // func fetchNewsSources(category: String) async -> Result<[SourceDTO], SuperNewsAPIError>
    func fetchNewsSources(category: String) async throws -> [SourceDTO]
    // func fetchNewsSources(language: String) async -> Result<[SourceDTO], SuperNewsAPIError>
    func fetchNewsSources(language: String) async throws -> [SourceDTO]
    // func fetchNewsSources(country: String) async -> Result<[SourceDTO], SuperNewsAPIError>
    func fetchNewsSources(country: String) async throws -> [SourceDTO]
    // func fetchTopHeadlinesNews(countryCode: String, category: String?) async -> Result<[ArticleDTO], SuperNewsAPIError>
    // func fetchTopHeadlinesNews(sourceName: String) async -> Result<[ArticleDTO], SuperNewsAPIError>
    func fetchTopHeadlinesNews(countryCode: String, category: String?) async throws -> [ArticleDTO]
    func fetchTopHeadlinesNews(sourceName: String) async throws -> [ArticleDTO]
    // func searchNewsFromEverything(with searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleDTO], SuperNewsAPIError>
    func searchNewsFromEverything(with searchQuery: String, language: String, sortBy: String) async throws -> [ArticleDTO]
}
