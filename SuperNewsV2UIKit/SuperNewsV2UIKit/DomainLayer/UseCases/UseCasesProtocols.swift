//
//  UseCasesProtocols.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation
import CoreLocation

// News fetch use cases
protocol TopHeadlinesUseCaseProtocol: Sendable {
    func execute(topHeadlinesOption: TopHeadlinesOption) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol SearchUseCaseProtocol {
    func execute(searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol CountryNewsUseCaseProtocol {
    func execute(countryCode: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

// Source selection use cases
protocol SourceSelectionUseCaseProtocol {
    func execute() async -> Result<[SourceCellViewModel], SuperNewsAPIError>
}

protocol LoadSavedSelectedSourceUseCaseProtocol {
    func execute() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError>
}

protocol SaveSelectedSourceUseCaseProtocol {
    func execute(with savedSource: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError>
}

// Map use cases
protocol MapUseCaseProtocol {
    func execute() async throws -> [CountryAnnotationViewModel]
}

protocol FetchUserLocationUseCaseProtocol: Sendable {
    func execute() async throws -> CLLocation
}

protocol ReverseGeocodingUseCaseProtocol: Sendable {
    func execute(location: CLLocation) async throws -> String
}

// User settings use cases
protocol UserSettingsUseCaseProtocol {
    func execute(with option: String) async throws -> [CountrySettingViewModel]
}

protocol ResetUserSettingsUseCaseProtocol {
    func execute() async -> Result<Void, SuperNewsUserSettingsError>
}

protocol LoadUserSettingsUseCaseProtocol: Sendable {
    func execute() async -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError>
}

protocol SaveUserSettingsUseCaseProtocol: Sendable {
    func execute(with countryLanguageSetting: CountryLanguageSettingDTO) async -> Result<Void, SuperNewsUserSettingsError>
}

protocol LoadPrivacyPolicyUseCaseProtocol {
    func execute() async -> Result<PrivacyPolicyDTO, SuperNewsLocalFileError>
}
