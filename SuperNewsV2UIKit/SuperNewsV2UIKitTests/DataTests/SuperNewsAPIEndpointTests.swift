//
//  SuperNewsAPIEndpointTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsAPIEndpointTests: XCTestCase {
    private func getStringURL(endpoint: SuperNewsAPIEndpoint) -> String {
        return endpoint.baseURL + endpoint.path
    }
    
    func testFetchAllSourcesURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchAllSources), "https://newsapi.org/v2/sources")
    }
    
    func testFetchSourcesWithCategoryURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchSourcesWithCategory(category: "business")), "https://newsapi.org/v2/sources?category=business")
    }
    
    func testFetchSourcesWithLanguageURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchSourcesWithLanguage(language: "fr")), "https://newsapi.org/v2/sources?language=fr")
    }
    
    func testFetchSourcesWithCountryURl() {
        XCTAssertEqual(getStringURL(endpoint: .fetchSourcesWithCountry(country: "fr")), "https://newsapi.org/v2/sources?country=fr")
    }
    
    func testFetchTopHeadlinesNewsWithCountryURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchTopHeadlinesNews(countryCode: "fr", category: nil)), "https://newsapi.org/v2/top-headlines?country=fr")
    }
    
    func testFetchTopHeadlinesNewsWithCountryAndCategoryURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchTopHeadlinesNews(countryCode: "fr", category: "sports")), "https://newsapi.org/v2/top-headlines?country=fr&category=sports")
    }
    
    func testFetchTopHeadlinesNewsWithSourceURL() {
        XCTAssertEqual(getStringURL(endpoint: .fetchTopHeadlinesNewsWithSource(name: "lequipe")), "https://newsapi.org/v2/top-headlines?sources=lequipe")
    }
    
    func testSearchNewsFromEverythingURL() {
        XCTAssertEqual(getStringURL(endpoint: .searchNewsFromEverything(searchQuery: "Paris", language: "fr", sortBy: "publishedAt")), "https://newsapi.org/v2/everything?q=Paris&language=fr&sortBy=publishedAt")
    }
}
