//
//  SuperNewsMockFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/07/2023.
//

import Foundation

final class SuperNewsMockFileService: SuperNewsLocalDataFileService {
    private let forceLoadFailure: Bool
    
    init(forceLoadFailure: Bool) {
        print("[SuperNewsMockFileService] Starting")
        self.forceLoadFailure = forceLoadFailure
    }
    
    func loadCountries() async -> Result<[Country], SuperNewsLocalFileError> {
        guard forceLoadFailure == false else {
            return .failure(.localFileError)
        }
        
        let countries = [
            Country(countryCode: "fr", countryName: "France", lat: 46.6423682169416, lon: 2.1940236627886227),
            Country(countryCode: "gb", countryName: "United Kingdom", lat: 53.97844735080214, lon: -2.852943909329258),
            Country(countryCode: "dz", countryName: "Algeria", lat: 28.3509697448891, lon: 2.65584647197691)
        ]
        
        return .success(countries)
    }
    
    func loadLanguages() async -> Result<[Language], SuperNewsLocalFileError> {
        guard forceLoadFailure == false else {
            return .failure(.localFileError)
        }
        
        let languages = [
            Language(languageCode: "fr", languageName: "French", languageDefaultFlag: "fr", defaultLanguage: true),
            Language(languageCode: "en", languageName: "English", languageDefaultFlag: "uk", defaultLanguage: false),
            Language(languageCode: "ar", languageName: "Arabic", languageDefaultFlag: "sa", defaultLanguage: false)
        ]
        
        return .success(languages)
    }
}
