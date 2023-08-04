//
//  SettingsSection.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/08/2023.
//

import Foundation

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case newsLanguage
    case newsCountry
    case newsReset
    
    var description: String {
        switch self {
        case .newsLanguage:
            return "language"
        case .newsCountry:
            return "country"
        case .newsReset:
            return "reset"
        }
    }
    
    var detail: String {
        switch self {
        case .newsLanguage:
            return "Langue des news"
        case .newsCountry:
            return "Pays des news"
        case .newsReset:
            return "Réinitialiser les paramètres"
        }
    }
}
