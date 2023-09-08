//
//  SuperNewsUserSettingsError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/08/2023.
//

import Foundation

enum SuperNewsUserSettingsError: String, Error {
    case userSettingsError = "errorOccured"
    case loadingError = "loadingError"
    case savingError = "savingError"
    case encodeError = "encodeSavingError"
    case decodeError = "decodeSavingError"
    case unknown = "unknown"
}
