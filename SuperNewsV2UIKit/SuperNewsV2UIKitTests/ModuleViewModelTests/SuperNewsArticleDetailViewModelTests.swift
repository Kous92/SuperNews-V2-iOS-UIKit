//
//  SuperNewsArticleDetailViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 15/05/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsArticleDetailViewModelTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable> = []
    var viewModel: ArticleDetailViewModel?
    var articleViewModel: ArticleViewModel?
    
    override func setUpWithError() throws {
        let articleViewModel = ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle())
        viewModel = ArticleDetailViewModel(with: articleViewModel)
    }
    
    func testUpdateArticleView() {
        let expectation1 = XCTestExpectation(description: "Update view with an ArticleViewModel")
        
        // Update binding
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] articleViewModel in
                print("Expectation fulfilled, ready to update.")
                self?.articleViewModel = articleViewModel
                expectation1.fulfill()
            }.store(in: &subscriptions)
        
        viewModel?.updateArticleView()
        wait(for: [expectation1], timeout: 10)
        XCTAssertNotNil(articleViewModel)
    }
}
