//
//  UseCasesProtocols.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

protocol TopHeadlinesUseCaseProtocol {
    func execute(topHeadlinesOption: TopHeadlinesOption) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}
