//
//  SourceSelectionUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

/// This use case loads all available sources from the API
final class SourceSelectionUseCase: SourceSelectionUseCaseProtocol {
    private let dataRepository: SuperNewsRepository
    
    init(dataRepository: SuperNewsRepository) {
        self.dataRepository = dataRepository
    }
    
    func execute() async -> Result<[SourceCellViewModel], SuperNewsAPIError> {
        return handleResult(with: await dataRepository.fetchAllNewsSources())
    }
    
    private func handleResult(with result: Result<[SourceDTO], SuperNewsAPIError>) -> Result<[SourceCellViewModel], SuperNewsAPIError> {
        switch result {
            case .success(let sources):
                return .success(parseViewModels(with: sources))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func parseViewModels(with sources: [SourceDTO]) -> [SourceCellViewModel] {
        var viewModels = [SourceCellViewModel]()
        sources.forEach { viewModels.append(SourceCellViewModel(with: $0)) }
        
        return viewModels
    }
}
