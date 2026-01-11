//
//  SourceSelectionOption.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/05/2023.
//

import Foundation

enum SourceSelectionOption: Sendable {
    case fetchAllSources
    case saveSelectedSource(name: String?)
}
