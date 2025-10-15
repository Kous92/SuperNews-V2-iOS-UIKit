//
//  SuperNewsLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

protocol SuperNewsLocationService: Sendable {
    func fetchLocation() async throws -> CLLocation
    func reverseGeocoding(location: CLLocation) async throws -> String
}
