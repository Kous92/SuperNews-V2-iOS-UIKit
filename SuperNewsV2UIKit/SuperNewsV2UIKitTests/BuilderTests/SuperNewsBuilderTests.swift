//
//  SuperNewsBuilderTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsBuilderTests: XCTestCase {

    private var moduleBuilder: ModuleBuilder?

    func testHomeModuleBuilder() {
        moduleBuilder = HomeModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: false)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is HomeViewController)
        
        guard let homeViewController = viewController as? HomeViewController else {
            XCTFail("The UIViewController is not a HomeViewController.")
            
            return
        }
        
        XCTAssertNotNil(homeViewController.viewModel)
    }
}
