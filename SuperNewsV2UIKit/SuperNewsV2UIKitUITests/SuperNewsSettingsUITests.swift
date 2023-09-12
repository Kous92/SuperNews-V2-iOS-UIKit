//
//  SuperNewsSettingsUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 12/09/2023.
//

import XCTest

final class SuperNewsSettingsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCUIApplication().launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }


    func testSettingsView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        XCTAssert(app.tables["tableView"].waitForExistence(timeout: 1.0))
        XCTAssert(app.staticTexts["Settings"].exists)
        XCTAssertEqual(app.tables["tableView"].cells.count, 3)
    }
    
    func testNewsLanguageSettings() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        XCTAssertEqual(tableView.cells.count, 3)
        
        tableView.cells.element(boundBy: 0).tap()
        XCTAssert(app.staticTexts["News language"].exists)
        
        let settingsChoiceTableView = app.tables["settingsChoiceTable"]
        XCTAssertTrue(settingsChoiceTableView.waitForExistence(timeout: 2.0))
        
        let cells = settingsChoiceTableView.cells
        XCTAssertGreaterThan(cells.count, 0)
        
        // 14 languages are available
        XCTAssertEqual(cells.count, 14)
        
        XCTAssert(app.staticTexts["English"].exists)
        cells.element(boundBy: 2).tap()
        
        app.swipeUp()
    }
    
    func testNewsCountrySettings() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        XCTAssertEqual(tableView.cells.count, 3)
        
        tableView.cells.element(boundBy: 1).tap()
        XCTAssert(app.staticTexts["News country"].exists)
        
        let settingsChoiceTableView = app.tables["settingsChoiceTable"]
        XCTAssertTrue(settingsChoiceTableView.waitForExistence(timeout: 2.0))
        
        let cells = settingsChoiceTableView.cells
        XCTAssertGreaterThan(cells.count, 0)
        
        // 14 languages are available
        XCTAssertEqual(cells.count, 54)
        
        XCTAssert(app.staticTexts["United Arab Emirates"].exists)
        cells.element(boundBy: 0).tap()
        
        app.swipeUp()
    }
    
    func testNewsResetSettings() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["Settings"].tap()
        
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        XCTAssertEqual(tableView.cells.count, 3)
        
        tableView.cells.element(boundBy: 2).tap()
        
        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Warning"].scrollViews.otherElements
        alert.buttons["Yes"].tap()
    }
}
