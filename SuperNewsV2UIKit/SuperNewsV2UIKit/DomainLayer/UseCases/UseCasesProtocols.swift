//
//  UseCasesProtocols.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation
import CoreLocation

protocol TopHeadlinesUseCaseProtocol {
    func execute(topHeadlinesOption: TopHeadlinesOption) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol SearchUseCaseProtocol {
    func execute(searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol CountryNewsUseCaseProtocol {
    func execute(countryCode: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol SourceSelectionUseCaseProtocol {
    func execute() async -> Result<[SourceCellViewModel], SuperNewsAPIError>
    func saveSelectedSource(with savedSource: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError>
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
    func fetchUserLocation() async -> Result<CLLocation, SuperNewsGPSError>
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError>
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
