//
//  SourceDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

/// Data Transfer Object as link between Data and Domain Layer
struct SourceDTO {
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
    
    init(with mediaSource: MediaSource) {
        self.id = mediaSource.id
        self.name = mediaSource.name
        self.description = mediaSource.description
        self.url = mediaSource.url
        self.category = mediaSource.category
        self.language = mediaSource.language
        self.country = mediaSource.country
    }
}
