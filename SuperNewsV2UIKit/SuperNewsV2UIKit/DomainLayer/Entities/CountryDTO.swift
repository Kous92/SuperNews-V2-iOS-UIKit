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
    
    init(with country: Country) {
        self.countryCode = country.countryCode
        self.countryName = country.countryCode.countryName() ?? country.countryName
        self.lat = country.lat
        self.lon = country.lon
    }
}

extension CountryDTO {
    static func getFakeObjectFromCountry() -> CountryDTO {
        return CountryDTO(with: Country.getFakeCountry())
    }
}
