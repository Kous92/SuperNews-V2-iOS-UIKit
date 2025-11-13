//
//  LoadPrivacyPolicyUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import Foundation

final class LoadPrivacyPolicyUseCase: LoadPrivacyPolicyUseCaseProtocol {
    private let privacyPolicyFileRepository: SuperNewsPrivacyPolicyFileRepository
    
    init(privacyPolicyFileRepository: SuperNewsPrivacyPolicyFileRepository) {
        self.privacyPolicyFileRepository = privacyPolicyFileRepository
    }
    
    func execute() async throws -> PrivacyPolicyDTO {
        return try await privacyPolicyFileRepository.loadPrivacyPolicy()
    }
}
