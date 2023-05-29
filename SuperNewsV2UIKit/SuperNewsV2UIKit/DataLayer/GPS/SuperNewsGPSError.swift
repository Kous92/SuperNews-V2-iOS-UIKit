//
//  SuperNewsGPSError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation

enum SuperNewsGPSError: String, Error {
    case restricted = "L'accès au service de localisation est restreint par le contrôle parental."
    case denied = "Vous avez refusé l'accès au service de localisation. Merci de l'autoriser en allant dans Réglages > Confidentialité > Service de localisation > SuperNews."
    case reverseGeocodingFailed = "Le pays où vous êtes localisé est inconnu."
    case serviceNotAvailable = "Service de localisation indisponible. Assurez-vous que le signal GPS soit disponible en vérifiant les autorisations dans Réglages > Confidentialité > Service de localisation > SuperNews."
    case unknown = "Erreur inconnue."
}
