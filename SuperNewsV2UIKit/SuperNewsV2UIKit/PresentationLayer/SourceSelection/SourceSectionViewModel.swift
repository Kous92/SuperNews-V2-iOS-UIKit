//
//  SourceSectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/04/2023.
//

import Foundation

struct SourceSectionViewModel {
    let sectionName: String
    let sourceCellViewModels: [SourceCellViewModel]
    
    init(sectionName: String, sourceCellViewModels: [SourceCellViewModel]) {
        self.sectionName = sectionName
        self.sourceCellViewModels = sourceCellViewModels
    }
}
