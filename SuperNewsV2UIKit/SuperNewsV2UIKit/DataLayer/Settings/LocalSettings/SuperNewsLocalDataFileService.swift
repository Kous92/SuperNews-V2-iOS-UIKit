//
//  SuperNewsLocalDataFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

protocol SuperNewsLocalDataFileService {
    func loadCountries() async -> Result<[Country], SuperNewsLocalFileError>
    func loadLanguages() async -> Result<[Language], SuperNewsLocalFileError>
}

protocol SuperNewsPrivacyPolicyLocalDataFileService {
    func loadPrivacyPolicy(userLanguage: String) async -> Result<PrivacyPolicy, SuperNewsLocalFileError>
}
