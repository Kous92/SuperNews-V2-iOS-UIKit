//
//  Country.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

struct Country: Decodable, Sendable {
    let countryCode, countryName: String
    let lat, lon: Double
}

extension Country {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeCountry() -> Country {
        return Country(countryCode: "fr", countryName: "France", lat: 46.6423682169416, lon: 2.1940236627886227)
    }
}
