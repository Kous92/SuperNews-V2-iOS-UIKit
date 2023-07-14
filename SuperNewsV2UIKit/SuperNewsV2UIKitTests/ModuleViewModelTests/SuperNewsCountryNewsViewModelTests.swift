//
//  SuperNewsCountryNewsViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsCountryNewsViewModelTests: XCTestCase {

    var subscriptions: Set<AnyCancellable> = []
    var viewModel: CountryNewsViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dataRepository = SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false))
        viewModel = CountryNewsViewModel(countryCode: "fr", useCase: CountryNewsUseCase(dataRepository: dataRepository))
    }
    
    func testFetchLocalTopHeadlines() {
        let expectation1 = XCTestExpectation(description: "Retrieve local top headlines news")
        
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
        
        viewModel?.fetchCountryTopHeadlines()
        wait(for: [expectation1], timeout: 10)
        
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
    
    func testCountryName() {
        let countryName = viewModel?.getCountryName()
        XCTAssertEqual(countryName, "France")
    }
}
