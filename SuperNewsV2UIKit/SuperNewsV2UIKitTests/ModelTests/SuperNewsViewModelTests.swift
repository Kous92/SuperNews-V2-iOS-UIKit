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
    
    func testSettingsSectionViewModel() {
        let fakeViewModel1 = SettingsSectionViewModel(with: .newsCountry)
        let fakeViewModel2 = SettingsSectionViewModel(with: .newsLanguage)
        let fakeViewModel3 = SettingsSectionViewModel(with: .newsReset)
        
        XCTAssertEqual(fakeViewModel1.description, "country")
        XCTAssertEqual(fakeViewModel2.description, "language")
        XCTAssertEqual(fakeViewModel3.description, "reset")
        XCTAssertEqual(fakeViewModel1.detail, "Pays des news")
        XCTAssertEqual(fakeViewModel2.detail, "Langue des news")
        XCTAssertEqual(fakeViewModel3.detail, "Réinitialiser les paramètres")
    }
    
    func testCountrySettingViewModel() {
        var fakeViewModel = CountrySettingViewModel(with: CountryDTO.getFakeObjectFromCountry())
        let fakeViewModel2 = CountrySettingViewModel(code: "dz", name: "Algeria", flagCode: "dz", isSaved: false)
        let fakeViewModel3 = CountrySettingViewModel(with: LanguageDTO.getFakeObjectFromLanguage())
        
        XCTAssertEqual(fakeViewModel.name, "France")
        XCTAssertFalse(fakeViewModel.isSaved)
        fakeViewModel.setIsSaved(saved: true)
        XCTAssertTrue(fakeViewModel.isSaved)
        XCTAssertEqual(fakeViewModel2.flagCode, "dz")
        XCTAssertEqual(fakeViewModel3.flagCode, "fr")
    }
}
