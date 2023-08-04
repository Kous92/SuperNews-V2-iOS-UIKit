//
//  SuperNewsLocalSettingsError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

enum SuperNewsLocalSettingsError: String, Error {
    case localSettingsError = "Une erreur est survenue."
    case encodeError = "Une erreur est survenue à l'encodage des données avant sauvegarde."
    case decodeError = "Une erreur est survenue au décodage des données chargées."
    case unknown = "Erreur inconnue."
}
