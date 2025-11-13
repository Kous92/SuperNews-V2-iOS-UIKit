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

protocol SearchUseCaseProtocol: Sendable {
    func execute(searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol CountryNewsUseCaseProtocol: Sendable {
    func execute(countryCode: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

// Source selection use cases
protocol SourceSelectionUseCaseProtocol: Sendable {
    func execute() async -> Result<[SourceCellViewModel], SuperNewsAPIError>
}

protocol LoadSavedSelectedSourceUseCaseProtocol: Sendable {
    func execute() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError>
}

protocol SaveSelectedSourceUseCaseProtocol: Sendable {
    func execute(with savedSource: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError>
}

// Map use cases
protocol MapUseCaseProtocol: Sendable {
    func execute() async throws -> [CountryAnnotationViewModel]
}

protocol FetchUserLocationUseCaseProtocol: Sendable {
    func execute() async throws -> CLLocation
}

protocol ReverseGeocodingUseCaseProtocol: Sendable {
    func execute(location: CLLocation) async throws -> String
}

// User settings use cases
protocol UserSettingsUseCaseProtocol: Sendable {
    func execute(with option: String) async throws -> [CountrySettingViewModel]
}

protocol ResetUserSettingsUseCaseProtocol: Sendable {
    @discardableResult func execute() async throws -> Bool
}

protocol LoadUserSettingsUseCaseProtocol: Sendable {
    func execute() async throws -> CountryLanguageSettingDTO
}

protocol SaveUserSettingsUseCaseProtocol: Sendable {
    @discardableResult func execute(with countryLanguageSetting: CountryLanguageSettingDTO) async throws -> Bool
}

protocol LoadPrivacyPolicyUseCaseProtocol: Sendable {
    func execute() async throws -> PrivacyPolicyDTO
}
