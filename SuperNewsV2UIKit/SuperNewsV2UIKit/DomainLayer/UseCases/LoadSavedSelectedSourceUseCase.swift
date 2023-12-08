//
//  LoadSavedSelectedSourceUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 08/12/2023.
//

import Foundation

/// This use case loads the selected favorite source from the user
final class LoadSavedSelectedSourceUseCase: LoadSavedSelectedSourceUseCaseProtocol {
    private let sourceSettingsRepository: SuperNewsSourceSettingsRepository
    
    init(sourceSettingsRepository: SuperNewsSourceSettingsRepository) {
        self.sourceSettingsRepository = sourceSettingsRepository
    }
    
    func execute() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError> {
        return await sourceSettingsRepository.loadSelectedMediaSource()
    }
}
