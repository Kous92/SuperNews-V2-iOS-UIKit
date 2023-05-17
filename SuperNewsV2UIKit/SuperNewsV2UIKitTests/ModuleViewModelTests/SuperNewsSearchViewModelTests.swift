//
//  SuperNewsSearchViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 18/05/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsSearchViewModelTests: XCTestCase {

    var subscriptions: Set<AnyCancellable> = []
    var viewModel: SearchViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dataRepository = SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false))
        let settingsRepository = SuperNewsUserDefaultsRepository(settingsService: SuperNewsMockLocalSettings())
        viewModel = SearchViewModel(useCase: SearchUseCase(dataRepository: dataRepository, settingsRepository: settingsRepository))
    }

    func testSearchNewsWithQuery() {
        let expectation = XCTestExpectation(description: "Get news from a search query")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                if updated {
                    print("Fulfilled")
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.searchQuery = "iPhone"
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
    }
}
