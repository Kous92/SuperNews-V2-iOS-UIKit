//
//  SuperNewsSourceSelectionViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 04/05/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsSourceSelectionViewModelTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable> = []
    var viewModel: SourceSelectionViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dataRepository = SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false))
        let settingsRepository = SuperNewsUserDefaultsRepository(settingsService: SuperNewsMockLocalSettings())
        viewModel = SourceSelectionViewModel(useCase: SourceSelectionUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository))
    }

    func testInitSourceCategories() {
        XCTAssertGreaterThan(viewModel?.numberOfItemsInCollectionView() ?? 0, 0)
    }
    
    func testFetchAllSources() {
        let expectation1 = XCTestExpectation(description: "Retrieve all sources")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation1.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.setSourceOption(with: "allSources")
        wait(for: [expectation1], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfSections() ?? 0, 0)
    }
    
    func testFetchAndSortByLanguage() {
        let expectation2 = XCTestExpectation(description: "Retrieve all sources and sort by language")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                print("Updated: \(updated)")
                if updated {
                    print("Main source loaded, ready for sorting")
                    self?.viewModel?.setSourceOption(with: "languageSources")
                }
            }.store(in: &subscriptions)
        
        // The binding before executing the loading of data.
        viewModel?.sortedUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation2.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [expectation2], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfSections() ?? 0, 0)
    }
    
    func testFetchAndSortByCategories() {
        let expectation2 = XCTestExpectation(description: "Retrieve all sources and sort by category")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                print("Updated: \(updated)")
                if updated {
                    print("Main source loaded, ready for sorting")
                    self?.viewModel?.setSourceOption(with: "categorySources")
                }
            }.store(in: &subscriptions)
        
        // The binding before executing the loading of data.
        viewModel?.sortedUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation2.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [expectation2], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfSections() ?? 0, 0)
    }
    
    func testFetchAndSortByCountry() {
        let expectation2 = XCTestExpectation(description: "Retrieve all sources and sort by country")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                print("Updated: \(updated)")
                if updated {
                    print("Main source loaded, ready for sorting")
                    self?.viewModel?.setSourceOption(with: "countrySources")
                }
            }.store(in: &subscriptions)
        
        // The binding before executing the loading of data.
        viewModel?.sortedUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                print("Updated: \(updated)")
                if updated {
                    print("Fulfilled")
                    expectation2.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [expectation2], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfSections() ?? 0, 0)
    }
}
