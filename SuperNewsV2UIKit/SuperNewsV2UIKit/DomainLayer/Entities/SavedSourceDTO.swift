//
//  SavedSourceDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

struct SavedSourceDTO {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(with savedSource: SavedSource) {
        self.id = savedSource.id
        self.name = savedSource.name
    }
    
    func getEncodableSavedSource() -> SavedSource {
        return SavedSource(id: self.id, name: self.name)
    }
}
