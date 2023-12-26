//
//  PrivacyTableViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/12/2023.
//

import Foundation

enum PrivacyCellIdentifier {
    case header
    case content
}

struct PrivacyTableViewModel {
    let headerViewModel: PrivacyHeaderViewModel
    let cellViewModels: [PrivacyCellViewModel]
    
    init(headerViewModel: PrivacyHeaderViewModel, cellViewModels: [PrivacyCellViewModel]) {
        self.headerViewModel = headerViewModel
        self.cellViewModels = cellViewModels
    }
}
