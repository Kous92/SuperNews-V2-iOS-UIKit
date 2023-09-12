//
//  SuperNewsTopHeadlinesUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 11/09/2023.
//

import XCTest

final class SuperNewsTopHeadlinesUITests: XCTestCase {    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().launch()
    }
    
    func testTopHeadlinesWithShareArticle() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        print(app.navigationBars.element)
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        
        let tableViewCells = tableView.cells
        XCTAssertGreaterThan(tableViewCells.count, 0)
        
        if tableViewCells.count > 0 {
            let promise = expectation(description: "Waiting for TableViewCells")
            
            for i in 0 ..< tableViewCells.count {
                // Grab the first cell and verify that it exists and tap it
                let tableCell = tableViewCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "Cell \(i) exists")
         
                if i == (tableViewCells.count - 1) {
                    promise.fulfill()
                }
            }
            waitForExpectations(timeout: 3, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
         
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
        
        tableView.swipeUp(velocity: .fast)
        sleep(1)
        tableView.swipeDown(velocity: .fast)
        
        tableViewCells.element(boundBy: 0).tap()
        XCTAssert(app.buttons["shareButton"].waitForExistence(timeout: 1.0))
        app.buttons["shareButton"].tap()
    }
    
    func testTopHeadlinesWithArticleWebsite() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        print(app.navigationBars.element)
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        
        let tableViewCells = tableView.cells
        XCTAssertGreaterThan(tableViewCells.count, 0)
        
        if tableViewCells.count > 0 {
            let promise = expectation(description: "Waiting for TableViewCells")
            
            for i in 0 ..< tableViewCells.count {
                // Grab the first cell and verify that it exists and tap it
                let tableCell = tableViewCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "Cell \(i) exists")
         
                if i == (tableViewCells.count - 1) {
                    promise.fulfill()
                }
            }
            waitForExpectations(timeout: 3, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
         
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
        
        tableView.swipeUp(velocity: .fast)
        sleep(1)
        tableView.swipeDown(velocity: .fast)
        
        tableViewCells.element(boundBy: 1).tap()
        XCTAssert(app.scrollViews["scrollView"].waitForExistence(timeout: 1.0))
        app.swipeUp()
        XCTAssert(app.buttons["websiteButton"].waitForExistence(timeout: 1.0))
        app.buttons["websiteButton"].tap()
        XCTAssert(app.webViews.firstMatch.waitForExistence(timeout: 1.0))
    }
    
    func testCategoryCollectionView() throws {
        let app = XCUIApplication()
        let collectionView = app.collectionViews["categoryCollectionView"]
        let collectionViewCells = collectionView.cells
        let cells = 0

        if collectionViewCells.count > 0 {
            let promise = expectation(description: "Waiting for CollectionViewCells")
            
            for i in 0 ..< collectionViewCells.count {
                // Grab the first cell and verify that it exists and tap it
                let collectionViewCell = collectionViewCells.element(boundBy: i)
                XCTAssertTrue(collectionViewCell.exists, "Cell \(i) exists")
         
                if i == (collectionViewCells.count - 1) {
                    promise.fulfill()
                }
            }
            waitForExpectations(timeout: 3, handler: nil)
            XCTAssertTrue(true, "Finished validating the CollectionView cells")
         
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
        
        collectionView.cells.element(boundBy: 1).tap()
        collectionView.cells.element(boundBy: 2).tap()
        XCTAssert(app.staticTexts["Business"].exists)
        collectionView.cells.element(boundBy: 3).tap()
        XCTAssert(app.staticTexts["Entertainment"].exists)
        collectionView.cells.element(boundBy: 4).tap()
        XCTAssert(app.staticTexts["General"].exists)
        collectionView.cells.element(boundBy: 1).tap()
        XCTAssert(app.staticTexts["Health"].exists)
        collectionView.cells.element(boundBy: 2).tap()
        XCTAssert(app.staticTexts["Science"].exists)
        collectionView.cells.element(boundBy: 3).tap()
        XCTAssert(app.staticTexts["Sports"].exists)
        collectionView.cells.element(boundBy: 4).tap()
        XCTAssert(app.staticTexts["Technology"].exists)
        collectionView.firstMatch.swipeRight()
        collectionView.firstMatch.swipeRight()
        collectionView.cells.element(boundBy: 0).tap()
        collectionView.firstMatch.swipeLeft()
    }
}
