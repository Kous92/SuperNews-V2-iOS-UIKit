//
//  CountrySettingViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/08/2023.
//

import Foundation

struct CountrySettingViewModel {
    let code: String
    let name: String
    private(set) var isSaved: Bool = false
    
    init(code: String, name: String, isSaved: Bool) {
        self.code = code
        self.name = name
        self.isSaved = isSaved
    }
}
