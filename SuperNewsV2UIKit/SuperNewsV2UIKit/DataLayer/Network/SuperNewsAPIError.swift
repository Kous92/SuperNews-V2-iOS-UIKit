//
//  SuperNewsAPIError.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import Foundation

enum SuperNewsAPIError: String, Error {
    case parametersMissing = "parametersMissing"
    case invalidApiKey = "invalidApiKey"
    case notFound = "notFound"
    case tooManyRequests = "tooManyRequests"
    case serverError = "serverError"
    case apiError = "apiError"
    case invalidURL = "invalidURL"
    case networkError = "networkError"
    case decodeError = "decodeDownloadError"
    case downloadError = "downloadError"
    case unknown = "unknownError"
}
