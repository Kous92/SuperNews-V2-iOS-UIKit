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
    func loadSavedSelectedSource() async -> Result<SavedSourceDTO, SuperNewsLocalSettingsError>
}

protocol SourceSelectionUseCaseProtocol {
    func execute() async -> Result<[SourceCellViewModel], SuperNewsAPIError>
    func saveSelectedSource(with savedSource: SavedSourceDTO) async -> Result<Void, SuperNewsLocalSettingsError>
}

protocol SearchUseCaseProtocol {
    func execute(searchQuery: String, language: String, sortBy: String) async -> Result<[ArticleViewModel], SuperNewsAPIError>
}

protocol MapUseCaseProtocol {
    func execute() async -> Result<[CountryAnnotationViewModel], SuperNewsLocalFileError>
    func fetchUserLocation() async -> Result<CLLocation, SuperNewsGPSError>
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError>
}
