//
//  SuperNewsLocalFileError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

enum SuperNewsLocalFileError: String, Error {
    case noCountries = "noCountries"
    case localFileError = "localFileError"
    case decodeError = "decodeSavingError"
    case unknown = "unknown"
}
