//
//  Language.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 09/08/2023.
//

import Foundation

struct Language: Decodable {
    let languageCode, languageName, languageDefaultFlag: String
    let defaultLanguage: Bool
}

extension Language {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeLanguage() -> Language {
        return Language(languageCode: "fr", languageName: "French", languageDefaultFlag: "fr", defaultLanguage: true)
    }
}
