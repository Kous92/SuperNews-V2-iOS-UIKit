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
    case newsPrivacyPolicy
    
    var description: String {
        switch self {
        case .newsLanguage:
            return "language"
        case .newsCountry:
            return "country"
        case .newsReset:
            return "reset"
        case .newsPrivacyPolicy:
            return "privacyPolicy"
        }
    }
    
    var detail: String {
        switch self {
        case .newsLanguage:
            return String(localized: "newsLanguage")
        case .newsCountry:
            return String(localized: "newsCountry")
        case .newsReset:
            return String(localized: "newsReset")
        case .newsPrivacyPolicy:
            return String(localized: "privacyPolicy")
        }
    }
}
