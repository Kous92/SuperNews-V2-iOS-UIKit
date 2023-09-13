//
//  SuperNewsV2UIKitUITests.swift
//  SuperNewsV2UIKitUITests
//
//  Created by Koussaïla Ben Mamar on 11/09/2023.
//

import XCTest

final class SuperNewsV2UIKitUITests: XCTestCase {
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().launch()
    }
    
    func testTabBars() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        XCTAssertEqual(app.tabBars.buttons.count, 4)
        XCTAssert(app.tabBars.buttons["Top headlines"].exists, "Top headlines TabBar button does not exist")
        XCTAssert(app.tabBars.buttons["Search"].exists, "Search TabBar button does not exist")
        XCTAssert(app.tabBars.buttons["World map"].exists, "World map TabBar button does not exist")
        XCTAssert(app.tabBars.buttons["Settings"].exists, "Settings TabBar button does not exist")
        
        app.tabBars.buttons["Search"].tap()
        sleep(1)
        app.tabBars.buttons["World map"].tap()
        sleep(1)
        app.tabBars.buttons["Settings"].tap()
        sleep(1)
        app.tabBars.buttons["Top headlines"].tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
