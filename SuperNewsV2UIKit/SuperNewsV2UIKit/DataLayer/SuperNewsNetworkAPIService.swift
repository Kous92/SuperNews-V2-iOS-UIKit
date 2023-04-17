//
//  SuperNewsNetworkAPIService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import Alamofire

final class SuperNewsNetworkAPIService: SuperNewsDataAPIService {
    func fetchAllNewsSources() async -> Result<[MediaSource], SuperNewsAPIError> {
        <#code#>
    }
    
    func fetchNewsSources(category: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        <#code#>
    }
    
    func fetchNewsSources(language: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        <#code#>
    }
    
    func fetchNewsSources(country: String) async -> Result<[MediaSource], SuperNewsAPIError> {
        <#code#>
    }
    
    func fetchTopHeadlinesNews(countryCode: String, category: String?) async -> Result<[Article], SuperNewsAPIError> {
        <#code#>
    }
    
    func fetchTopHeadlinesNews(sourceName: String) async -> Result<[Article], SuperNewsAPIError> {
        <#code#>
    }
    
    func searchNewsFromEverything(with searchQuery: String, language: String, sortBy: String) async -> Result<[Article], SuperNewsAPIError> {
        <#code#>
    }
}
