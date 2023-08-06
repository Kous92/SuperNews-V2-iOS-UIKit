//
//  CountryLanguageSetting.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation

struct CountryLanguageSetting: Codable {
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    func getDTO() -> CountryLanguageSettingDTO {
        return CountryLanguageSettingDTO(name: self.name, code: self.code)
    }
}

extension CountryLanguageSetting {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeCountryLanguageSetting() -> CountryLanguageSetting {
        return CountryLanguageSetting(name: "France", code: "fr")
    }
}
