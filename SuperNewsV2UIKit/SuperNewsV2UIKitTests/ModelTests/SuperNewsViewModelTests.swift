//
//  SuperNewsViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import Foundation

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsViewModelTests: XCTestCase {
    func testCountryAnnoationViewModel() {
        let fakeViewModel = CountryAnnotationViewModel.getFakeCountryAnnotationViewModel()
        
        XCTAssertEqual(fakeViewModel.countryCode, "fr")
        XCTAssertEqual(fakeViewModel.countryName, "France")
        XCTAssertEqual(fakeViewModel.coordinates.latitude, 46.6423682169416)
        XCTAssertEqual(fakeViewModel.coordinates.longitude, 2.1940236627886227)
    }
}
