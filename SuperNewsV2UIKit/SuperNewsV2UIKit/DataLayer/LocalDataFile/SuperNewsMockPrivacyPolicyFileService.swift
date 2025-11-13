//
//  SuperNewsMockPrivacyPolicyFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/12/2023.
//

import Foundation

final class SuperNewsMockPrivacyPolicyFileService: SuperNewsPrivacyPolicyLocalDataFileService {
    private let forceLoadFailure: Bool
    
    init(forceLoadFailure: Bool) {
        print("[SuperNewsMockPrivacyPolicyFileService] Starting")
        self.forceLoadFailure = forceLoadFailure
    }
    
    func loadPrivacyPolicy(userLanguage: String) async throws -> PrivacyPolicy {
        print("[SuperNewsMockPrivacyPolicyFileService] Loading privacy policy")
        guard forceLoadFailure == false else {
            throw SuperNewsLocalFileError.localFileError
        }
        
        return PrivacyPolicy.getFakePrivacyPolicy()
    }
}
