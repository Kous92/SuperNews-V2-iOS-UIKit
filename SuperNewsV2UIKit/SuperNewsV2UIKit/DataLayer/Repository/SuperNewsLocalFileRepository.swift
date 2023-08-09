//
//  SuperNewsLocalFileRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

protocol SuperNewsLocalFileRepository {
    func loadCountries() async -> Result<[CountryDTO], SuperNewsLocalFileError>
    func loadLanguages() async -> Result<[LanguageDTO], SuperNewsLocalFileError>
}
