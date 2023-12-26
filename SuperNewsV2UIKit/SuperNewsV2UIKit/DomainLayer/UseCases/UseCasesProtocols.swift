//
//  UseCasesProtocols.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation
import CoreLocation

// News fetch use cases
protocol TopHeadlinesUseCaseProtocol {
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
    func execute() async -> Result<[CountryAnnotationViewModel], SuperNewsLocalFileError>
}

protocol FetchUserLocationUseCaseProtocol {
    func execute() async -> Result<CLLocation, SuperNewsGPSError>
}

protocol ReverseGeocodingUseCaseProtocol {
    func execute(location: CLLocation) async -> Result<String, SuperNewsGPSError>
}

// User settings use cases
protocol UserSettingsUseCaseProtocol {
    func execute(with option: String) async -> Result<[CountrySettingViewModel], SuperNewsLocalFileError>
}

protocol ResetUserSettingsUseCaseProtocol {
    func execute() async -> Result<Void, SuperNewsUserSettingsError>
}

protocol LoadUserSettingsUseCaseProtocol {
    func execute() async -> Result<CountryLanguageSettingDTO, SuperNewsUserSettingsError>
}

protocol SaveUserSettingsUseCaseProtocol {
    func execute(with countryLanguageSetting: CountryLanguageSettingDTO) async -> Result<Void, SuperNewsUserSettingsError>
}

protocol LoadPrivacyPolicyUseCaseProtocol {
    func execute() async -> Result<PrivacyPolicyDTO, SuperNewsLocalFileError>
}
