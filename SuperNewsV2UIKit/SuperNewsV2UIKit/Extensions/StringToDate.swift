//
//  StringToDate.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

extension String {
    // Converting date format string "yyyy-MM-dd'T'HH:mm:ss+0000Z" to "dd/MM/yyyy à HH:mm" format
    func stringToDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = formatter.date(from: self) else {
            return "Date de publication inconnue"
        }
        
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: date) // Jour, mois, année
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let timeString = formatter.string(from: date) // Heure, minutes
        
        return "Le " + dateString + " à " + timeString
    }
}
