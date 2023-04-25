//
//  NewsCellViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

struct NewsCellViewModel {
    let imageURL: String
    let title: String
    let source: String
    
    init(imageURL: String, title: String, source: String) {
        self.imageURL = imageURL
        self.title = title
        self.source = source
    }
}
