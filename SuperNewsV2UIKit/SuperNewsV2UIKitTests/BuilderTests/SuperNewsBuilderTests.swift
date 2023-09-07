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
    
    func testArticleDetailModuleBuilder() {
        let viewModel = ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle())
        moduleBuilder = ArticleDetailModuleBuilder(articleViewModel: viewModel)
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is ArticleDetailViewController, "The UIViewController is not a ArticleDetailViewController.")
    }
    
    func testSearchModuleBuilder() {
        moduleBuilder = SearchModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is SearchViewController, "The UIViewController is not a SearchViewController.")
    }
    
    func testMapModuleBuilder() {
        moduleBuilder = MapModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is MapViewController, "The UIViewController is not a MapViewController.")
    }
    
    func testCountryModuleBuilder() {
        moduleBuilder = CountryNewsModuleBuilder(countryCode: "fr")
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is CountryNewsViewController, "The UIViewController is not a CountryNewsViewController.")
    }
    
    func testSettingsModuleBuilder() {
        moduleBuilder = SettingsModuleBuilder()
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is SettingsViewController, "The UIViewController is not a SettingsViewController.")
    }
    
    func testSettingsSelectionModuleBuilder() {
        moduleBuilder = SettingsSelectionModuleBuilder(settingSection: SettingsSection.newsLanguage) // Can be done also with "country" section
        XCTAssertNotNil(moduleBuilder)
        
        // Checking dependency injections
        let viewController = moduleBuilder?.buildModule(testMode: true, coordinator: nil)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is SettingsSelectionViewController, "The UIViewController is not a SettingsSelectionViewController.")
    }
}
