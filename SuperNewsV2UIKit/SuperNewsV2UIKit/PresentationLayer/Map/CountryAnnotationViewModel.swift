//
//  CountryAnnotationViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 22/05/2023.
//

import Foundation
import CoreLocation

struct CountryAnnotationViewModel {
    let countryName: String
    let countryCode: String
    let coordinates: CLLocationCoordinate2D
    
    init(countryName: String, countryCode: String, coordinates: CLLocationCoordinate2D) {
        self.countryName = countryName
        self.countryCode = countryCode
        self.coordinates = coordinates
    }
    
    init(with country: CountryDTO) {
        self.countryName = country.countryName
        self.countryCode = country.countryCode
        self.coordinates = CLLocationCoordinate2D(latitude: country.lat, longitude: country.lon)
    }
}
