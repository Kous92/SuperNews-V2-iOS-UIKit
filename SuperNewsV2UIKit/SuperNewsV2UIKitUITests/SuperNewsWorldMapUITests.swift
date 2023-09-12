//
//  SuperNewsWorldMapUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 12/09/2023.
//

import XCTest

final class SuperNewsWorldMapUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCUIApplication().launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testMapView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars.buttons["World map"].tap()
        
        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Suggestion"].scrollViews.otherElements
        alert.buttons["Yes"].tap()
        
        XCTAssert(app.buttons["locationButton"].waitForExistence(timeout: 1.0))
        XCTAssert(app.buttons["zoomButton"].waitForExistence(timeout: 1.0))
        
        let searchBar = app.searchFields["Search"]
        XCTAssert(searchBar.waitForExistence(timeout: 1.0))
        searchBar.tap()
        
        XCTAssert(app.otherElements["map"].waitForExistence(timeout: 1.0))
    }
    
    func testMapAlertNoOption() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.tabBars.buttons["World map"].tap()
        
        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Suggestion"].scrollViews.otherElements
        alert.buttons["No"].tap()
    }
    
    func testMapViewButtons() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["World map"].tap()

        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Suggestion"].scrollViews.otherElements
        alert.buttons["Yes"].tap()
        
        app.buttons["zoomButton"].tap()
        app.buttons["locationButton"].tap()
    }
    
    func testMapAnnotationToNewsCountryView() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.tabBars.buttons["World map"].tap()

        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Suggestion"].scrollViews.otherElements
        alert.buttons["Yes"].tap()
        
        XCTAssert(app.otherElements["annotationus"].firstMatch.waitForExistence(timeout: 2.0))
        let usAnnotation = app.otherElements["annotationus"]
        usAnnotation.tap()
        
        XCTAssert(app.staticTexts["Local news: United States"].firstMatch.waitForExistence(timeout: 2.0))
    }
    
    func testMapSearch() {
        let app = XCUIApplication()
        app.tabBars.buttons["World map"].tap()
        
        XCTAssert(app.alerts.firstMatch.waitForExistence(timeout: 2.0))
        let alert = app.alerts["Suggestion"].scrollViews.otherElements
        alert.buttons["Yes"].tap()
        
        let searchBar = app.searchFields["Search"]
        XCTAssert(searchBar.waitForExistence(timeout: 1.0))
        searchBar.tap()
        searchBar.typeText("France")
        app/*@START_MENU_TOKEN@*/.staticTexts["France"]/*[[".otherElements[\"map\"].staticTexts[\"France\"]",".staticTexts[\"France\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssert(app.otherElements["annotationfr"].firstMatch.waitForExistence(timeout: 2.0))
    }
}
