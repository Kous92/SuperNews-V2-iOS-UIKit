//
//  SuperNewsLocationRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

/// The link between app layer (domain) and data layer of SuperNews app Clean Architecture. This class follows the Repository design pattern to provide an abstraction of data part, as interface to retrieve data. This repository handles all location part.
protocol SuperNewsLocationRepository: AnyObject, Sendable {
    func fetchLocation() async throws -> CLLocation
    func reverseGeocoding(location: CLLocation) async throws -> String
}
