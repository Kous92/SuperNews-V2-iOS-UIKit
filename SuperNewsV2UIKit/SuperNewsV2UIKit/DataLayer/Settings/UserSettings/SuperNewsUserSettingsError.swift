//
//  SuperNewsUserSettingsError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/08/2023.
//

import Foundation

enum SuperNewsUserSettingsError: String, Error {
    case userSettingsError = "Une erreur est survenue."
    case loadingError = "Une erreur est survenue au chargement du paramètre."
    case savingError = "Une erreur est survenue à la sauvegarde du paramètre."
    case encodeError = "Une erreur est survenue à l'encodage des données avant sauvegarde."
    case decodeError = "Une erreur est survenue au décodage des données chargées."
    case unknown = "Erreur inconnue."
}
