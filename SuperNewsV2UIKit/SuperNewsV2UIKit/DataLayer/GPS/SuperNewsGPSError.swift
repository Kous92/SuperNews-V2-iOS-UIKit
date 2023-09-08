//
//  SuperNewsGPSError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation

enum SuperNewsGPSError: String, Error {
    case restricted = "restrictedError"
    case denied = "deniedError"
    case reverseGeocodingFailed = "reverseGeocodingError"
    case serviceNotAvailable = "gpsServiceNotAvailableError"
    case unknown = "unknown"
}
