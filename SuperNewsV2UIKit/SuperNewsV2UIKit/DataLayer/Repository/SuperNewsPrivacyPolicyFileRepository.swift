//
//  SuperNewsPrivacyPolicyFileRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/12/2023.
//

import Foundation

final class SuperNewsPrivacyPolicyFileRepository: SuperNewsPrivacyPolicyRepository {
    private let localFileService: SuperNewsPrivacyPolicyLocalDataFileService?
    
    init(localFileService: SuperNewsPrivacyPolicyLocalDataFileService?) {
        self.localFileService = localFileService
    }
    
    func loadPrivacyPolicy() async -> Result<PrivacyPolicyDTO, SuperNewsLocalFileError> {
        guard let result = await localFileService?.loadPrivacyPolicy(userLanguage: getLocale().uppercased()) else {
            return .failure(.localFileError)
        }
        
        return handlePrivacyPolicyResult(with: result)
    }
    
    private func handlePrivacyPolicyResult(with result: Result<PrivacyPolicy, SuperNewsLocalFileError>) -> Result<PrivacyPolicyDTO, SuperNewsLocalFileError> {
        switch result {
            case .success(let privacyPolicy):
                return .success(entityToDTO(with: privacyPolicy))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    /// Converts PrivacyPolicy data to PrivacyPolicy Data Transfer Object for Domain Layer
    private func entityToDTO(with privacyPolicy: PrivacyPolicy) -> PrivacyPolicyDTO {
        return PrivacyPolicyDTO(with: privacyPolicy)
    }
}
