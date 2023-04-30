//
//  StringExtensions.swift
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
    
    // From the ISO code, it gives the country full name.
    func countryName() -> String? {
        let current = Locale(identifier: "fr_FR")
        return current.localizedString(forRegionCode: self)
    }
    
    // From the ISO code, it gives the language full name.
    func languageName() -> String? {
        // Urdu language
        if self == "ud" {
            return "ourdou"
        }
        
        let current = Locale(identifier: "fr_FR")
        return current.localizedString(forLanguageCode: self)
    }
    
    // Fix some unavailable countries due to confusing codes and conform to NewsAPI options
    func checkCountryISO3166_1Alpha1Code() -> String {
        // "is" was normally Iceland, but NewsAPI refers "is" to Israel. Correct code is "il".
        // "zh" is unknown, but NewsAPI refers "zh" to China. Correct code is "cn".
        if self.lowercased() == "is" {
            return "il"
        } else if self.lowercased() == "zh" {
            return "cn"
        } else {
            return self
        }
    }
    
    func getCategoryNameFromCategoryCode() -> String {
        switch self {
            case "local": return "Actualités locales"
            case "general": return "Général"
            case "business": return "Business"
            case "entertainment": return "Divertissement"
            case "health": return "Santé"
            case "technology": return "Technologie"
            case "sports": return "Sports"
            case "science": return "Science"
            default: return self
        }
    }
}
