//
//  StringExtensions.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

func getLocale() -> String {
    return Locale.current.languageCode ?? ""
}

extension String {
    // Converting date format string "yyyy-MM-dd'T'HH:mm:ss+0000Z" to "dd/MM/yyyy à HH:mm" format
    func stringToFullDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = formatter.date(from: self) else {
            return String(localized: "unknownDate")
        }
        
        let locale = Locale.current
        if locale.languageCode == "fr" {
            formatter.locale = Locale(identifier: "fr_FR")
        }
        
        formatter.dateStyle = .short
        
        let dateString = formatter.string(from: date) // Day, month, year
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let timeString = formatter.string(from: date) // Hours, minutes
        
        return locale.languageCode == "fr" ? "Le " + dateString + " à " + timeString : dateString + " at " + timeString
    }
    
    // Converting date format string "yyyy-MM-dd to "dd/MM/yyyy" format
    func stringToDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: self) else {
            return String(localized: "unknownDate")
        }
        
        let locale = Locale.current
        if locale.languageCode == "fr" {
            formatter.locale = Locale(identifier: "fr_FR")
        }
        
        formatter.dateStyle = .long
        let dateString = formatter.string(from: date) // Day, month, year
        
        return dateString
    }
    
    // From the ISO code, it gives the country full name.
    func countryName() -> String? {
        let current = Locale.current
        return current.localizedString(forRegionCode: self)
    }
    
    // From the ISO code, it gives the language full name.
    func languageName() -> String? {
        // Urdu language
        if self == "ud" {
            return String(localized: "urdu")
        }
        
        let current = Locale.current
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
            case "local": return String(localized: "localNews")
            case "general": return String(localized: "general")
            case "business": return String(localized: "business")
            case "entertainment": return String(localized: "entertainment")
            case "health": return String(localized: "health")
            case "technology": return String(localized: "technology")
            case "sports": return String(localized: "sports")
            case "science": return String(localized: "science")
            default: return self
        }
    }
}
