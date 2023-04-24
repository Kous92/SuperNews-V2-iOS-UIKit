//
//  SuperNewsCoordinatorTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsCoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coordinator = AppCoordinator(with: GradientTabBarController())
    }
    
    func testAppCoordinatorRootViewController() {
        let viewController = coordinator?.start()
        XCTAssertTrue(viewController is GradientTabBarController)
        
        if let gradientTabBar = viewController as? GradientTabBarController {
            XCTAssertEqual(gradientTabBar.tabBar.items?.count ?? 0, 2)
        } else {
            XCTFail()
        }
    }
    
    func testHomeCoordinator() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let homeViewController = homeCoordinator.start()
        XCTAssertTrue(homeViewController is HomeViewController)
    }
    
    func testSearchCoordinator() {
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        let searchViewController = searchCoordinator.start()
        XCTAssertTrue(searchViewController is SearchViewController)
    }
}
