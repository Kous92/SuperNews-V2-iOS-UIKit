//
//  SuperNewsUserDefaultsRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/05/2023.
//

import Foundation

final class SuperNewsUserDefaultsRepository: SuperNewsSettingsRepository {
    
    private let settingsService: SuperNewsLocalSettings?
    
    init(settingsService: SuperNewsLocalSettings?) {
        self.settingsService = settingsService
    }
    
    func saveSelectedMediaSource(source: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError> {
        guard let result = await settingsService?.saveSelectedMediaSource(source: dtoToSavedSource(with: source)) else {
            return .failure(.localSettingsError)
        }
        
        return result
    }
    
    func loadSelectedMediaSource() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError> {
        guard let result = await settingsService?.loadSelectedMediaSource() else {
            return .failure(.localSettingsError)
        }
        
        return handleSavedSourceResult(with: result)
    }
    
    private func handleSavedSourceResult(with result: Result<SavedSource, SuperNewsLocalSettingsError>) -> Result<SavedSourceDTO, SuperNewsLocalSettingsError> {
        switch result {
            case .success(let articles):
                return .success(savedSourceToDTO(with: articles))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    /// Converts Data Transfer Object to encodable SavedSource for Data Layer
    private func dtoToSavedSource(with dto: SavedSourceDTO) -> SavedSource {
        return dto.getEncodableSavedSource()
    }
    
    /// Converts SavedSource data objects to Source Data Transfer Object for Domain Layer
    private func savedSourceToDTO(with savedSource: SavedSource) -> SavedSourceDTO {
        return savedSource.getDTO()
    }
}
