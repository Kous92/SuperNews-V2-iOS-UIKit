//
//  SaveSelectedSourceUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 08/12/2023.
//

import Foundation

/// This use case saves the selected favorite source from the user
final class SaveSelectedSourceUseCase: SaveSelectedSourceUseCaseProtocol {
    private let sourceSettingsRepository: SuperNewsSourceSettingsRepository
    
    init(sourceSettingsRepository: SuperNewsSourceSettingsRepository) {
        self.sourceSettingsRepository = sourceSettingsRepository
    }
    
    func execute(with savedSource: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError> {
        return await sourceSettingsRepository.saveSelectedMediaSource(source: savedSource)
    }
}
