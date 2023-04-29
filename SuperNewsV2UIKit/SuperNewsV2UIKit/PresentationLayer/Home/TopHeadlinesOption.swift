//
//  TopHeadlinesOption.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

enum TopHeadlinesOption {
    case categoryNews(name: String, countryCode: String)
    case localCountryNews(countryCode: String)
    case sourceNews(name: String)
}
