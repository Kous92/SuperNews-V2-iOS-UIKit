//
//  SourceCellViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

struct SourceCellViewModel {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
    
    init(id: String, name: String, description: String, url: String, category: String, language: String, country: String) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
    
    init(with source: SourceDTO) {
        self.id = source.id
        self.name = source.name
        self.description = source.description
        self.url = source.url
        self.category = source.category
        self.language = source.language
        self.country = source.country.checkCountryISO3166_1Alpha1Code()
    }
    
    func getURL() -> URL? {
        guard !url.isEmpty, let url = URL(string: url) else {
            print("-> ERROR: Source URL not available.")
            return nil
        }
        
        return url
    }
}
