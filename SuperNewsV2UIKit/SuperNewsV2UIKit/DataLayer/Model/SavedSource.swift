//
//  SavedSource.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

struct SavedSource: Codable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(with dto: SavedSourceDTO) {
        self.id = dto.id
        self.name = dto.name
    }
    
    func getDTO() -> SavedSourceDTO {
        return SavedSourceDTO(id: self.id, name: self.name)
    }
}
