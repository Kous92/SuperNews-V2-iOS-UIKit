//
//  CountryLanguageSetting.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation

struct CountryLanguageSetting: Codable, Sendable {
    let name: String
    let code: String
    let flagCode: String
    
    init(name: String, code: String, flagCode: String) {
        self.name = name
        self.code = code
        self.flagCode = code
    }
    
    func getDTO() -> CountryLanguageSettingDTO {
        return CountryLanguageSettingDTO(name: self.name, code: self.code, flagCode: self.code)
    }
}

extension CountryLanguageSetting {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeCountryLanguageSetting() -> CountryLanguageSetting {
        return CountryLanguageSetting(name: "France", code: "fr", flagCode: "fr")
    }
}
