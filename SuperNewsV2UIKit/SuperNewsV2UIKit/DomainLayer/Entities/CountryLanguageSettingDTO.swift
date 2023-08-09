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
    let flagCode: String
    
    init(name: String, code: String, flagCode: String) {
        self.name = name
        self.code = code
        self.flagCode = flagCode
    }
    
    init(with setting: CountryLanguageSetting) {
        self.name = setting.name
        self.code = setting.code
        self.flagCode = setting.flagCode
    }
    
    func getCountryLanguageSetting() -> CountryLanguageSetting {
        return CountryLanguageSetting(name: self.name, code: self.code, flagCode: self.flagCode)
    }
}

extension CountryLanguageSettingDTO {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeObjectFromCountryLanguageSetting() -> CountryLanguageSettingDTO {
        return CountryLanguageSettingDTO(name: "France", code: "fr", flagCode: "fr")
    }
}
