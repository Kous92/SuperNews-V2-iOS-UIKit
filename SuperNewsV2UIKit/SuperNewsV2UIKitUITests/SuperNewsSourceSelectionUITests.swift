//
//  SuperNewsSourceSelectionUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 12/09/2023.
//

import XCTest

final class SuperNewsSourceSelectionUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCUIApplication().launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testSourceSelection() throws {
        let app = XCUIApplication()

        XCTAssert(app.buttons["listButton"].waitForExistence(timeout: 1.0))
        app.buttons["listButton"].tap()
        XCTAssert(app.tables["tableView"].waitForExistence(timeout: 1.0))
        XCTAssert(app.collectionViews["collectionView"].waitForExistence(timeout: 1.0))
        XCTAssert(app.otherElements["searchBar"].waitForExistence(timeout: 1.0), "Search bar does not exist.")
        
        app.tables["tableView"].swipeUp(velocity: .fast)
    }
    
    func testCategoryCollectionView() throws {
        let app = XCUIApplication()
        app.buttons["listButton"].tap()
        
        let collectionView = app.collectionViews["collectionView"]
        XCTAssert(collectionView.waitForExistence(timeout: 1.0))
        XCTAssertEqual(collectionView.cells.count, 4)
        
        collectionView.swipeLeft()
        sleep(1)
        XCTAssert(app.staticTexts["All sources"].exists)
        XCTAssert(app.staticTexts["By language"].exists)
        XCTAssert(app.staticTexts["By country"].exists)
        XCTAssert(app.staticTexts["By category"].exists)
        
        collectionView.cells.element(boundBy: 1).tap()
        collectionView.cells.element(boundBy: 2).tap()
        collectionView.cells.element(boundBy: 3).tap()
        collectionView.swipeRight()
        collectionView.cells.element(boundBy: 0).tap()
    }
    
    func testSearchSource() throws {
        let app = XCUIApplication()
        app.buttons["listButton"].tap()
        
        let searchBar = app.otherElements["searchBar"]
        XCTAssert(searchBar.waitForExistence(timeout: 1.0), "Search bar does not exist.")
        
        searchBar.tap()
        searchBar.typeText("Hacker News")
        
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        XCTAssertEqual(tableView.cells.count, 1)
    }
    
    func testSearchSourceNoContent() throws {
        let app = XCUIApplication()
        app.buttons["listButton"].tap()
        
        let searchBar = app.otherElements["searchBar"]
        XCTAssert(searchBar.waitForExistence(timeout: 1.0), "Search bar does not exist.")
        searchBar.tap()
        searchBar.typeText("dlsbvlkbvr") // Some gibberish to ensure nothing will be found
        XCTAssert(app.keyboards.buttons["Search"].waitForExistence(timeout: 1.0))
        app.keyboards.buttons["Search"].tap()
        
        XCTAssert(app.staticTexts["noResultLabel"].waitForExistence(timeout: 1.0), "No result label does not exists")
    }
}
