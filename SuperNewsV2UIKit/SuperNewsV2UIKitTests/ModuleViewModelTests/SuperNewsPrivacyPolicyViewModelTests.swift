//
//  SuperNewsPrivacyPolicyViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 26/12/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsPrivacyPolicyViewModelTests: XCTestCase {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: PrivacyPolicyViewModel?
    private var sectionName1 = ""
    private var sectionName2 = ""
    private var fulfilledCount = 0
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let privacyPolicyFileRepository = SuperNewsPrivacyPolicyFileRepository(localFileService: SuperNewsMockPrivacyPolicyFileService(forceLoadFailure: false))
        let loadPrivacyPolicyUseCase = LoadPrivacyPolicyUseCase(privacyPolicyFileRepository: privacyPolicyFileRepository)
        
        viewModel = PrivacyPolicyViewModel(loadPrivacyPolicyUseCase: loadPrivacyPolicyUseCase)
    }
    
    @MainActor func testLoadPrivacyPolicy() throws {
        let expectation1 = XCTestExpectation(description: "Load privacy policy")
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink {
                expectation1.fulfill()
            }.store(in: &subscriptions)
        
        viewModel?.loadPrivacyPolicy()
        
        wait(for: [expectation1], timeout: 10)
        XCTAssertEqual(viewModel?.numberOfRowsInTableView() ?? 0, 3)
        XCTAssertEqual(viewModel?.getCellIdentifier(at: IndexPath(row: 0, section: 0)), .header)
        XCTAssertEqual(viewModel?.getCellIdentifier(at: IndexPath(row: 1, section: 0)), .content)
    }
}
