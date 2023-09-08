//
//  SuperNewsLocalSettingsError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

enum SuperNewsLocalSettingsError: String, Error {
    case localSettingsError = "errorOccured"
    case encodeError = "encodeSavingError"
    case decodeError = "decodeSavingError"
    case unknown = "unknown"
}
