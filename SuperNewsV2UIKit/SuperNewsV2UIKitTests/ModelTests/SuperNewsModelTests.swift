//
//  SuperNewsModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsModelTests: XCTestCase {
    
    private func getFilePath(name: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            XCTFail("The required file \(name).json is not available, cannot test decoding data.")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        
        return nil
    }
    
    private func getMediaSourceData() -> [MediaSource] {
        guard let fileURL = getFilePath(name: "AllSourcesMockData") else {
            return []
        }
        
        let output: MediaSourceOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(MediaSourceOutput.self, from: data)
            
            if let mediaSources = output?.sources {
                return mediaSources
            } else {
                XCTFail("Data decoding has failed.")
            }
        } catch {
            XCTFail("An error has occured: \(error)")
        }
        
        return []
    }
    
    private func getArticles() -> [Article] {
        guard let fileURL = getFilePath(name: "EverythingArticleOutputMockData") else {
            return []
        }
        
        let output: ArticleOutput?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            output = decode(ArticleOutput.self, from: data)
            
            if let articles = output?.articles {
                return articles
            } else {
                XCTFail("Data decoding has failed.")
            }
        } catch {
            XCTFail("An error has occured: \(error)")
        }
        
        return []
    }

    func testFakeMediaSourceObject() {
        let fake = MediaSource.getFakeObject()
        
        XCTAssertEqual(fake.id, "le-monde")
        XCTAssertEqual(fake.name, "Le Monde")
        XCTAssertEqual(fake.description, "Les articles du journal et toute l'actualité; en continu : International, France, Société, Économie, Culture, Environnement, Blogs ...")
        XCTAssertEqual(fake.url, "http://www.lemonde.fr")
        XCTAssertEqual(fake.category, "general")
        XCTAssertEqual(fake.language, "fr")
        XCTAssertEqual(fake.country, "fr")
    }
    
    func testDecodeMediaSourceData() {
        let mediaSourceData = getMediaSourceData()
        
        XCTAssertGreaterThan(mediaSourceData.count, 0)
    }
    
    func testFilterMediaSourceData() {
        let mediaSourceData = getMediaSourceData().filter { $0.country == "fr" }
        
        print(mediaSourceData.count)
        XCTAssertGreaterThan(mediaSourceData.count, 0)
    }
    
    let data = Article(
        source: ArticleSource(id: nil, name: "Google News"),
        author: "Pure People",
        title: "Hervé Temime, grand maître du barreau : les causes de sa mort à seulement 65 ans révélées - Pure People",
        description: nil,
        url: "https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy5wdXJlcGVvcGxlLmNvbS9hcnRpY2xlL2hlcnZlLXRlbWltZS1ncmFuZC1tYWl0cmUtZHUtYmFycmVhdS1sZXMtY2F1c2VzLWRlLXNhLW1vcnQtYS1zZXVsZW1lbnQtNjUtYW5zLXJldmVsZWVzX2E1MDcxNjkvMdIBAA?oc=5",
        urlToImage: nil,
        publishedAt: "2023-03-27T17:33:52Z",
        content: nil
    )
    
    // We will test here an object with not nil attributes
    func testFakeArticleObject() {
        let fake = Article.getFakeArticle()
        
        // Not nil attributes
        XCTAssertEqual(fake.source?.id ?? "", "mac-rumors")
        XCTAssertEqual(fake.source?.name ?? "", "MacRumors")
        XCTAssertEqual(fake.title ?? "", "iOS 16.4 Expands iPhone 14's Emergency SOS via Satellite to Six More Countries")
        XCTAssertEqual(fake.author ?? "", "Joe Rossignol")
        XCTAssertEqual(fake.description ?? "", "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 update released today to function in these countries.\n\n\n\n\n\nEmer…")
        XCTAssertEqual(fake.url ?? "", "https://www.macrumors.com/2023/03/27/emergency-sos-via-satellite-six-more-countries/")
        XCTAssertEqual(fake.urlToImage ?? "", "https://images.macrumors.com/t/NiqVm75fJdfBoWGMCBRbMJjPAU0=/3564x/article-new/2022/11/Emergency-SOS-via-Satellite-iPhone-YT.jpg")
        XCTAssertEqual(fake.publishedAt ?? "", "2023-03-27T17:33:52Z")
        XCTAssertEqual(fake.content ?? "", "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 upd… [+958 chars]")
    }
    
    // We will test here an object with nil content
    func testFakeArticleObjectWithNilAttributes() {
        let fake = Article.getFakeArticleWithNilContent()
        
        // Nil attributes
        XCTAssertNil(fake.source?.id, "The id attribute from source attribute should be nil. It's not nil currently.")
        XCTAssertNil(fake.description, "The description attribute should be nil. It's not nil currently.")
        XCTAssertNil(fake.urlToImage, "The urlToImage attribute should be nil. It's not nil currently.")
        XCTAssertNil(fake.content, "The content attribute should be nil. It's not nil currently.")
        
        // Not nil attributes
        XCTAssertEqual(fake.source?.name ?? "", "Google News")
        XCTAssertEqual(fake.title ?? "", "Hervé Temime, grand maître du barreau : les causes de sa mort à seulement 65 ans révélées - Pure People")
        XCTAssertEqual(fake.author ?? "", "Pure People")
        XCTAssertEqual(fake.url ?? "", "https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy5wdXJlcGVvcGxlLmNvbS9hcnRpY2xlL2hlcnZlLXRlbWltZS1ncmFuZC1tYWl0cmUtZHUtYmFycmVhdS1sZXMtY2F1c2VzLWRlLXNhLW1vcnQtYS1zZXVsZW1lbnQtNjUtYW5zLXJldmVsZWVzX2E1MDcxNjkvMdIBAA?oc=5")
        XCTAssertEqual(fake.publishedAt ?? "", "2023-03-27T17:33:52Z")
    }
    
    func testDecodingArticlesOutput() {
        let articles = getArticles()
        
        XCTAssertGreaterThan(articles.count, 0)
    }
    
    func testSavedSource() {
        let fakeSavedSource = SavedSource(id: "le-monde", name: "Le Monde")
        let fakeSavedSource2 = SavedSource(with: SavedSourceDTO.getFakeObjectFromSavedSource())
        
        XCTAssertEqual(fakeSavedSource.name, "Le Monde")
        XCTAssertEqual(fakeSavedSource.getDTO().name, "Le Monde")
        XCTAssertEqual(fakeSavedSource2.name, "Le Parisien")
    }
    
    func testPrivacyPolicy() {
        let fakePrivacyPolicy = PrivacyPolicy.getFakePrivacyPolicy()
        
        XCTAssertEqual(fakePrivacyPolicy.title, "SuperNews Privacy Policy")
        XCTAssertEqual(fakePrivacyPolicy.updateDate, "2023-12-26")
        XCTAssertEqual(fakePrivacyPolicy.sections.count, 2)
        XCTAssertEqual(fakePrivacyPolicy.sections[1].subtitle, "Contact")
        XCTAssertEqual(fakePrivacyPolicy.sections[1].content, "Contact at supernewsiosapp@gmail.com.")
    }
}
