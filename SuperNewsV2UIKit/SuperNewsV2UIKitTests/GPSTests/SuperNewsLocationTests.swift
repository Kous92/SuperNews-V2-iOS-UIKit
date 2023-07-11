//
//  SuperNewsLocationTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 11/07/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsLocationTests: XCTestCase {
    
    func testFetchLocationSuccess() async {
        let locationCaller = SuperNewsLocationServiceTestCaller()
        let result = await locationCaller.fetchLocationSuccess()
        XCTAssertTrue(locationCaller.invokedFetchLocation)
        XCTAssertEqual(locationCaller.invokedFetchLocationCount, 1)
        
        switch result {
            case .success(let location):
                XCTAssertEqual(location.coordinate.latitude, 2.301540063286635)
                XCTAssertEqual(location.coordinate.longitude, 48.87255175759405)
            case .failure(_):
                XCTFail()
        }
    }
    
    func testFetchLocationFailure() async {
        let locationCaller = SuperNewsLocationServiceTestCaller()
        let result = await locationCaller.fetchLocationFailure()
        XCTAssertTrue(locationCaller.invokedFetchLocation)
        XCTAssertEqual(locationCaller.invokedFetchLocationCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .serviceNotAvailable)
        }
    }
    
    func testReverseGeocodingSuccess() async {
        let locationCaller = SuperNewsLocationServiceTestCaller()
        let result = await locationCaller.reverseGeocodingSuccess()
        XCTAssertTrue(locationCaller.invokedReverseGeocoding)
        XCTAssertEqual(locationCaller.invokedReverseGeocodingCount, 1)
        
        switch result {
            case .success(let location):
                XCTAssertEqual(location, "France")
            case .failure(_):
                XCTFail()
        }
    }
    
    func testReverseGeocodingFailure() async {
        let locationCaller = SuperNewsLocationServiceTestCaller()
        let result = await locationCaller.reverseGeocodingFailure()
        XCTAssertTrue(locationCaller.invokedReverseGeocoding)
        XCTAssertEqual(locationCaller.invokedReverseGeocodingCount, 1)
        
        switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .reverseGeocodingFailed)
        }
    }
}
