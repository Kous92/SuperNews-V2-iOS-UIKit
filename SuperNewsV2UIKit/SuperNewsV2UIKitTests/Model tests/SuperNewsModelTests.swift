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
            XCTFail("The required file \(name) is not available, cannot test decoding data.")
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
        guard let fileURL = getFilePath(name: "MediaSourcesMockData") else {
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
}
