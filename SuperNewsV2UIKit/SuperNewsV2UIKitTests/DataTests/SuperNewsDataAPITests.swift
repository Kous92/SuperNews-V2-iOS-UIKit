//
//  SuperNewsDataAPITests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 15/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsDataAPITests: XCTestCase {
    
    func testFetchAllNewsSourcesSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchAllNewsSourcesSuccess()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchAllNewsSourcesFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchAllNewsSourcesFailure()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
        }
    }
    
    func testFetchCategoryNewsSourcesSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchCategoryNewsSourcesSuccess()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchCategoryNewsSourcesFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchCategoryNewsSourcesFailure()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testFetchCountryNewsSourcesSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchCountryNewsSourcesSuccess()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchCountryNewsSourcesFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchCountryNewsSourcesFailure()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testFetchLanguageNewsSourcesSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchLanguageNewsSourcesSuccess()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchLanguageNewsSourcesFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchLanguageNewsSourcesFailure()
        XCTAssertTrue(networkCaller.invokedFetchNewsSources)
        XCTAssertEqual(networkCaller.invokedFetchNewsSourcesCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testFetchTopHeadlinesNewsWithCountrySuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithCountrySuccess()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchTopHeadlinesNewsWithCountryFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithCountryFailure()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testFetchTopHeadlinesNewsWithCategorySuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithCountrySuccess()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchTopHeadlinesNewsWithCategoryFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithCountryFailure()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testFetchTopHeadlinesNewsWithSourceSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithSourceSuccess()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchTopHeadlinesNewsWithSourceFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.fetchTopHeadlinesNewsWithSourceFailure()
        XCTAssertTrue(networkCaller.invokedFetchTopHeadlinesNews)
        XCTAssertEqual(networkCaller.invokedFetchTopHeadlinesNewsCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func testSearchNewsFromEverythingSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.searchNewsFromEverythingSuccess()
        XCTAssertTrue(networkCaller.invokedSearchNewsFromEverything)
        XCTAssertEqual(networkCaller.invokedSearchNewsFromEverythingCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testSearchNewsFromEverythingFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.searchNewsFromEverythingFailure()
        XCTAssertTrue(networkCaller.invokedSearchNewsFromEverything)
        XCTAssertEqual(networkCaller.invokedSearchNewsFromEverythingCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .apiError)
        }
    }
    
    func testSearchNewsFromEverythingWithLanguageSuccess() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.searchNewsFromEverythingWithLanguageSuccess()
        XCTAssertTrue(networkCaller.invokedSearchNewsFromEverything)
        XCTAssertEqual(networkCaller.invokedSearchNewsFromEverythingCount, 1)
        
        switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testSearchNewsFromEverythingWithLanguageFailure() async {
        let networkCaller = SuperNewsDataAPIServiceTestCaller()
        let result = await networkCaller.searchNewsFromEverythingWithLanguageFailure()
        XCTAssertTrue(networkCaller.invokedSearchNewsFromEverything)
        XCTAssertEqual(networkCaller.invokedSearchNewsFromEverythingCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
        }
    }
}
