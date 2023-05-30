//
//  SuperNewsLocalFileError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

enum SuperNewsLocalFileError: String, Error {
    case noCountries = "Aucun pays disponible."
    case localFileError = "Le fichier n'existe pas."
    case decodeError = "Une erreur est survenue au décodage des données chargées."
    case unknown = "Erreur inconnue."
}
