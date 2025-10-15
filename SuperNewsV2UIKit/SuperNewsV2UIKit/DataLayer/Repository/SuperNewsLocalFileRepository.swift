//
//  SuperNewsLocalFileRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

protocol SuperNewsLocalFileRepository {
    func loadCountries() async throws -> [CountryDTO]
    func loadLanguages() async throws -> [LanguageDTO]
}

protocol SuperNewsPrivacyPolicyRepository {
    func loadPrivacyPolicy() async -> Result<PrivacyPolicyDTO, SuperNewsLocalFileError>
}
