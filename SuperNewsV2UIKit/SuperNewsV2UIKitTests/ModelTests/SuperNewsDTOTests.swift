//
//  SuperNewsDTOTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsDTOTests: XCTestCase {
    func testArticleDTO() {
        let fakeArticleDTO = ArticleDTO.getFakeObjectFromArticle()

        XCTAssertEqual(fakeArticleDTO.sourceName, "MacRumors")
        XCTAssertEqual(fakeArticleDTO.title, "iOS 16.4 Expands iPhone 14's Emergency SOS via Satellite to Six More Countries")
        XCTAssertEqual(fakeArticleDTO.author, "Joe Rossignol")
        XCTAssertEqual(fakeArticleDTO.description, "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 update released today to function in these countries.\n\n\n\n\n\nEmer…")
        XCTAssertEqual(fakeArticleDTO.sourceUrl, "https://www.macrumors.com/2023/03/27/emergency-sos-via-satellite-six-more-countries/")
        XCTAssertEqual(fakeArticleDTO.imageUrl, "https://images.macrumors.com/t/NiqVm75fJdfBoWGMCBRbMJjPAU0=/3564x/article-new/2022/11/Emergency-SOS-via-Satellite-iPhone-YT.jpg")
        XCTAssertEqual(fakeArticleDTO.publishedAt, "2023-03-27T17:33:52Z")
        XCTAssertEqual(fakeArticleDTO.content, "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 upd… [+958 chars]")
    }
    
    func testSavedSourceDTO() {
        let fakeSavedSourceDTO = SavedSourceDTO.getFakeObjectFromSavedSource()
        
        XCTAssertEqual(fakeSavedSourceDTO.id, "le-parisien")
        XCTAssertEqual(fakeSavedSourceDTO.name, "Le Parisien")
        
        let encodedSavedSource = fakeSavedSourceDTO.getEncodableSavedSource()
        
        XCTAssertEqual(encodedSavedSource.id, fakeSavedSourceDTO.id)
        XCTAssertEqual(encodedSavedSource.name, fakeSavedSourceDTO.name)
    }
    
    func testCountryDTO() {
        let fakeCountryDTO = CountryDTO.getFakeObjectFromCountry()
        
        XCTAssertEqual(fakeCountryDTO.countryCode, "fr")
        XCTAssertEqual(fakeCountryDTO.countryName, "France")
        XCTAssertEqual(fakeCountryDTO.lat, 46.6423682169416)
        XCTAssertEqual(fakeCountryDTO.lon, 2.1940236627886227)
    }
    
    func testLanguageDTO() {
        let fakeLanguageDTO = LanguageDTO.getFakeObjectFromLanguage()
        
        XCTAssertEqual(fakeLanguageDTO.languageCode, "fr")
        XCTAssertEqual(fakeLanguageDTO.languageDefaultFlag, "fr")
        XCTAssertEqual(fakeLanguageDTO.defaultLanguage, true)
        XCTAssertEqual(fakeLanguageDTO.languageName, String(localized: "french"))
    }
    
    func testSourceDTO() {
        let fakeSourceDTO = SourceDTO.getFakeObjectFromSource()
        
        XCTAssertEqual(fakeSourceDTO.language, "fr")
        XCTAssertEqual(fakeSourceDTO.category, "general")
        XCTAssertEqual(fakeSourceDTO.country, "fr")
        XCTAssertEqual(fakeSourceDTO.name, "Le Monde")
    }
    
    func testCountryLanguageSettingDTO() {
        let fakeCountryLanguageSettingDTO = CountryLanguageSettingDTO.getFakeObjectFromCountryLanguageSetting()
        
        XCTAssertEqual(fakeCountryLanguageSettingDTO.code, "fr")
        XCTAssertEqual(fakeCountryLanguageSettingDTO.flagCode, "fr")
        XCTAssertEqual(fakeCountryLanguageSettingDTO.name, "France")
        
        let countryLanguageSetting = fakeCountryLanguageSettingDTO.getCountryLanguageSetting()
        XCTAssertEqual(countryLanguageSetting.code, fakeCountryLanguageSettingDTO.code)
        XCTAssertEqual(countryLanguageSetting.flagCode, fakeCountryLanguageSettingDTO.flagCode)
        XCTAssertEqual(countryLanguageSetting.name, fakeCountryLanguageSettingDTO.name)
        
        let fakeCountryLanguageSettingDTO2 = CountryLanguageSettingDTO(with: CountryLanguageSetting.getFakeCountryLanguageSetting())
        XCTAssertEqual(fakeCountryLanguageSettingDTO2.code, "fr")
        XCTAssertEqual(fakeCountryLanguageSettingDTO2.flagCode, "fr")
        XCTAssertEqual(fakeCountryLanguageSettingDTO2.name, "France")
    }
    
    func testPrivacyPolicyDTO() {
        let fakePrivacyPolicyDTO = PrivacyPolicyDTO.getFakeObjectFromPrivacyPolicy()
        
        XCTAssertEqual(fakePrivacyPolicyDTO.title, "SuperNews Privacy Policy")
        XCTAssertEqual(fakePrivacyPolicyDTO.updateDate, "2023-12-26")
        XCTAssertEqual(fakePrivacyPolicyDTO.sections.count, 2)
        XCTAssertEqual(fakePrivacyPolicyDTO.sections[1].subtitle, "Contact")
        XCTAssertEqual(fakePrivacyPolicyDTO.sections[1].content, "Contact at supernewsiosapp@gmail.com.")
    }
}
