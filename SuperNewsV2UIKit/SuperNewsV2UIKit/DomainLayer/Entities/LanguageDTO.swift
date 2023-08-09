//
//  LanguageDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 09/08/2023.
//

import Foundation

/// Data Transfer Object as link between Data and Domain Layer
struct LanguageDTO {
    let languageCode, languageName, languageDefaultFlag: String
    let defaultLanguage: Bool
    
    init(languageCode: String, languageName: String, languageDefaultFlag: String, defaultLanguage: Bool) {
        self.languageCode = languageCode
        self.languageName = languageName
        self.languageDefaultFlag = languageDefaultFlag
        self.defaultLanguage = defaultLanguage
    }
    
    init(with language: Language) {
        self.languageCode = language.languageCode
        self.languageName = language.languageName
        self.languageDefaultFlag = language.languageDefaultFlag
        self.defaultLanguage = language.defaultLanguage
    }
}

extension LanguageDTO {
    static func getFakeObjectFromLanguage() -> LanguageDTO {
        return LanguageDTO(with: Language.getFakeLanguage())
    }
}
