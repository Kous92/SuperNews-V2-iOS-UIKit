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
    let flagCode: String
    private(set) var isSaved: Bool = false
    
    init(code: String, name: String, flagCode: String, isSaved: Bool) {
        self.code = code
        self.name = name
        self.flagCode = flagCode
        self.isSaved = isSaved
    }
    
    init(with country: CountryDTO) {
        self.name = country.countryName
        self.code = country.countryCode
        self.flagCode = country.countryCode
        self.isSaved = false
    }
    
    init(with language: LanguageDTO) {
        self.name = language.languageName
        self.code = language.languageCode
        self.flagCode = language.languageDefaultFlag
        self.isSaved = false
    }
    
    mutating func setIsSaved(saved: Bool) {
        self.isSaved = saved
    }
}
