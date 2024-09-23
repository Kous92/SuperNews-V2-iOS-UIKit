//
//  PrivacyHeaderViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/12/2023.
//

import Foundation

struct PrivacyHeaderViewModel: Sendable {
    let title: String
    let date: String
    
    init(title: String, date: String) {
        self.title = title
        self.date = date.stringToDateFormat()
    }
}
