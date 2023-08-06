//
//  CountryLanguageSettingDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 04/08/2023.
//

import Foundation

struct CountryLanguageSettingDTO {
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    init(with setting: CountryLanguageSetting) {
        self.name = setting.name
        self.code = setting.code
    }
    
    func getCountryLanguageSetting() -> CountryLanguageSetting {
        return CountryLanguageSetting(name: self.name, code: self.code)
    }
}

extension CountryLanguageSettingDTO {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeObjectFromCountryLanguageSetting() -> CountryLanguageSettingDTO {
        return CountryLanguageSettingDTO(name: "France", code: "fr")
    }
}
