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
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController(), builder: HomeModuleBuilder(), testMode: true)
        let navigationController = homeCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] is HomeViewController)
    }
    
    func testSearchCoordinator() {
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        let searchViewController = searchCoordinator.start()
        XCTAssertTrue(searchViewController is SearchViewController)
    }
}
