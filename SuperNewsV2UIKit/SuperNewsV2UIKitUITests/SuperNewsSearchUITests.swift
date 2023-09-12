//
//  SuperNewsSearchUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 12/09/2023.
//

import XCTest

final class SuperNewsSearchUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().launch()
    }

    func testSearchNoContentFound() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        app.tabBars.buttons["Search"].tap()
        XCTAssert(app.otherElements["searchBar"].waitForExistence(timeout: 1.0), "Search bar does not exist.")
        
        let searchBar = app.otherElements["searchBar"]
        searchBar.tap()
        searchBar.typeText("dlsbvlkbvr") // Some gibberish to ensure nothing will be found
        XCTAssert(app.keyboards.buttons["Search"].waitForExistence(timeout: 1.0))
        app.keyboards.buttons["Search"].tap()
        
        XCTAssert(app.staticTexts["noResultLabel"].waitForExistence(timeout: 1.0), "No result label does not exists")
    }
    
    func testSearchWithContent() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        app.tabBars.buttons["Search"].tap()
        XCTAssert(app.otherElements["searchBar"].waitForExistence(timeout: 1.0), "Search bar does not exist.")
        
        let searchBar = app.otherElements["searchBar"]
        searchBar.tap()
        searchBar.typeText("Apple")
        XCTAssert(app.keyboards.buttons["Search"].waitForExistence(timeout: 1.0))
        app.keyboards.buttons["Search"].tap()
        
        let tableView = app.tables["tableView"]
        XCTAssert(tableView.waitForExistence(timeout: 1.0))
        
        let tableViewCells = tableView.cells
        XCTAssertGreaterThan(tableViewCells.count, 0)
        // XCTAssert(app.staticTexts["noResultLabel"].label)
        
        
        /*
        let app = XCUIApplication()
        let barreDOngletsTabBar = app.tabBars["Barre d’onglets"]
        barreDOngletsTabBar.buttons["Recherche"].tap()
        app/*@START_MENU_TOKEN@*/.searchFields["Recherche (langue: français)"]/*[[".otherElements[\"searchBar\"].searchFields[\"Recherche (langue: français)\"]",".searchFields[\"Recherche (langue: français)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements["searchBar"].children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Annuler"]/*[[".otherElements[\"searchBar\"]",".buttons[\"Annuler\"].staticTexts[\"Annuler\"]",".staticTexts[\"Annuler\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        barreDOngletsTabBar.buttons["Actualités"].tap()
        app.tables["tableView"].cells.containing(.staticText, identifier:"Le Vietnam et les Etats-Unis mettent en garde contre \"l'usage de la force\" en mer de Chine méridionale - franceinfo").children(matching: .other).element.tap()
        app.navigationBars["SuperNewsV2UIKit.ArticleDetailView"].buttons["Actualités"].tap()
         */
        
    }
}
