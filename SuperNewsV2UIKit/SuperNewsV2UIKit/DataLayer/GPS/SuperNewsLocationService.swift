//
//  SuperNewsLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

protocol SuperNewsLocationService {
    func fetchLocation() async -> Result<CLLocation, SuperNewsGPSError>
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError>
}
