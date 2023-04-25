//
//  UseCasesProtocols.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

protocol TopHeadlinesUseCaseProtocol {
    func execute(source: String) async -> Result<[NewsCellViewModel], SuperNewsAPIError>
    func execute(countryCode: String, category: String?) async -> Result<[NewsCellViewModel], SuperNewsAPIError>
}
