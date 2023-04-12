//
//  SuperNewsDataAPIService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import Foundation

protocol SuperNewsDataAPIService {
    func fetchTopHeadlinesNews(with countryCode: String, with category: String?) async -> Result<[Article], SuperNewsAPIError>
    func searchNewsFromEverything(with searchQuery: String, from: String?, to: String?, sortBy: String?) async -> Result<[Article], SuperNewsAPIError>
    func searchNewsFromTopHeadlines(with searchQuery: String, from: String?, to: String?, sortBy: String?) async -> Result<[Article], SuperNewsAPIError>
}
