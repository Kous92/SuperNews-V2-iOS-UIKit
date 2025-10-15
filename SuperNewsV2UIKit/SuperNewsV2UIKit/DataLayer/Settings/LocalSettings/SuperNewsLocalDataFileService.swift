//
//  SuperNewsLocalDataFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

protocol SuperNewsLocalDataFileService {
    func loadCountries() async throws -> [Country]
    func loadLanguages() async throws -> [Language]
}

protocol SuperNewsPrivacyPolicyLocalDataFileService {
    func loadPrivacyPolicy(userLanguage: String) async -> Result<PrivacyPolicy, SuperNewsLocalFileError>
}
