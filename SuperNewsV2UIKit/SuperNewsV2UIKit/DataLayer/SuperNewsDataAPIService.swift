//
//  SuperNewsDataAPIService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import Foundation

protocol SuperNewsDataAPIService {
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError>
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError>
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError>
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError>
    func fetchTopHeadlinesNews(countryCode: String, category: String?) async -> Result<[Article], SuperNewsAPIError>
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[Article], SuperNewsAPIError>
    func searchNewsFromEverything(with searchQuery: String, language: String, sortBy: String) async -> Result<[Article], SuperNewsAPIError>
}
