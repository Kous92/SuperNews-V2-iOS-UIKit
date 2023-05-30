//
//  CountryDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

/// Data Transfer Object as link between Data and Domain Layer
struct CountryDTO {
    let countryCode, countryName: String
    let lat, lon: Double
    
    init(countryCode: String, countryName: String, lat: Double, lon: Double) {
        self.countryCode = countryCode
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
    }
    
    init(with country: Country) {
        self.countryCode = country.countryCode
        self.countryName = country.countryName
        self.lat = country.lat
        self.lon = country.lon
    }
}

extension CountryDTO {
    static func getFakeObjectFromCountry() -> CountryDTO {
        return CountryDTO(with: Country.getFakeCountry())
    }
}