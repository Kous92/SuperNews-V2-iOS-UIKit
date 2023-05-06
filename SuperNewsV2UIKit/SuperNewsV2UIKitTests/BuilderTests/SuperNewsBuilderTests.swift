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

    func testTopHeadlinesModuleBuilder() {
        moduleBuilder = TopHeadlinesModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is TopHeadlinesViewController)
        
        guard let topHeadlinesViewController = viewController as? TopHeadlinesViewController else {
            XCTFail("The UIViewController is not a TopHeadlinesViewController.")
            
            return
        }
        
        XCTAssertNotNil(topHeadlinesViewController.viewModel)
    }
    
    func testSourceSelectionModuleBuilder() {
        moduleBuilder = SourceSelectionModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is SourceSelectionViewController)
        
        guard let sourceSelectionViewController = viewController as? SourceSelectionViewController else {
            XCTFail("The UIViewController is not a SourceSelectionViewController.")
            
            return
        }
        
        XCTAssertNotNil(sourceSelectionViewController.viewModel)
    }
}
