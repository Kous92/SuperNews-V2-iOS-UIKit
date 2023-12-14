//
//  SuperNewsTopHeadlinesViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 04/05/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsTopHeadlinesViewModelTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable> = []
    var viewModel: TopHeadlinesViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dataRepository = SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false))
        let sourceSettingsRepository = SuperNewsSourceUserDefaultsRepository(settingsService: SuperNewsMockLocalSettings())
        let userSettingsRepository = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "language"))
        
        let topHeadlinesUseCase = TopHeadlinesUseCase(dataRepository: dataRepository)
        let loadSavedSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(sourceSettingsRepository: sourceSettingsRepository)
        let loadUserSettingsUseCase = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository)
        
        viewModel = TopHeadlinesViewModel(topHeadlinesUseCase: topHeadlinesUseCase, loadSavedSelectedSourceUseCase: loadSavedSelectedSourceUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase)
    }
    
    func testInitNewsCategories() {
        let expectation1 = XCTestExpectation(description: "Retrieve different top headlines news categories")
        
        // The binding before executing the loading of data.
        viewModel?.categoryUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { reload, indexUpdate in
                print("Updated: \(reload)")
                if reload {
                    print("Fulfilled")
                    expectation1.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.initCategories()
        viewModel?.loadAndUpdateSourceCategoryTitle()
        wait(for: [expectation1], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfItemsInCollectionView() ?? 0, 0)
    }
    
    func testFetchLocalTopHeadlines() {
        let expectation2 = XCTestExpectation(description: "Retrieve local top headlines news")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation2.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines()
        wait(for: [expectation2], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithSource() {
        let expectation3 = XCTestExpectation(description: "Retrieve top headlines news with source")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation3.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlinesWithSource()
        wait(for: [expectation3], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithBusinessCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "business")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithSportsCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "sports")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithHealthCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "health")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithEntertainmentCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "entertainment")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithGeneralCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "general")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithTechnologyCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "technology")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testFetchTopHeadlinesWithScienceCategory() {
        let expectation4 = XCTestExpectation(description: "Retrieve top headlines news with category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.fetchTopHeadlines(with: "science")
        wait(for: [expectation4], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
}
