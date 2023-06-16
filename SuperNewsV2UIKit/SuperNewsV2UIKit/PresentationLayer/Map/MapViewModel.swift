//
//  MapViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import Foundation
import Combine
import CoreLocation

final class MapViewModel {
    private var annotationsViewModels = [CountryAnnotationViewModel]()
    private var autocompletionViewModels = [CountryAnnotationViewModel]()
    
    // Delegate
    weak var coordinator: MapViewControllerDelegate?
    private let useCase: MapUseCaseProtocol
    
    // User position on map
    private var userMapPosition = CLLocation()
    private var locatedCountryName: String = ""
    
    // MARK: - Bindings
    private var updateResult = PassthroughSubject<Bool, Never>()
    private var userLocation = PassthroughSubject<CLLocation, SuperNewsGPSError>()
    private var countryAnnotations = PassthroughSubject<Bool, Never>()
    @Published var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    
    var updateResultPublisher: AnyPublisher<Bool, Never> {
        return updateResult.eraseToAnyPublisher()
    }
    
    var userLocationPublisher: AnyPublisher<CLLocation, SuperNewsGPSError> {
        return userLocation.eraseToAnyPublisher()
    }
    
    var countryAnnotationPublisher: AnyPublisher<Bool, Never> {
        return countryAnnotations.eraseToAnyPublisher()
    }
    
    init(useCase: MapUseCaseProtocol) {
        self.useCase = useCase
        setBindings()
    }
    
    func getLocation() {
        Task {
            print("[MapViewModel] Getting user location")
            let result = await useCase.fetchUserLocation()
            
            switch result {
                case .success(let userCoordinates):
                    print("[MapViewModel] User location retrieved, ready for map with coordinates: x = \(userCoordinates.coordinate.longitude), y = \(userCoordinates.coordinate.latitude)")
                    self.userMapPosition = userCoordinates
                    print("[MapViewModel] Ready for reverse geocoding")
                    await positionReverseGeocoding()
                case .failure(let error):
                    print("[MapViewModel] Impossible to retrieve user location.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    func loadCountries() {
        Task {
            print("[MapViewModel] Loading countries")
            let result = await useCase.execute()
            
            switch result {
                case .success(let annotations):
                    self.annotationsViewModels = annotations
                    self.autocompletionViewModels = annotations
                    print("[MapViewModel] Countries loaded successfully, ready to display on map")
                    self.countryAnnotations.send(true)
                    self.updateResult.send(true)
                case .failure(let error):
                    print("[MapViewModel] Loading failed.")
                    print("ERROR: \(error.rawValue)")
                    await self.sendErrorMessage(with: error.rawValue)
            }
        }
    }
    
    private func positionReverseGeocoding() async {
        let result = await useCase.reverseGeocoding(location: userMapPosition)
        
        switch result {
            case .success(let address):
                self.locatedCountryName = address
                print("[MapViewModel] Reverse geocoding succeeded, located country is \(address)")
                await self.getClosestCountryFromPosition()
            case .failure(let error):
                print("[MapViewModel] Reverse geocoding failed. ERROR: \(error.rawValue)")
                self.userLocation.send(userMapPosition)
        }
    }
    
    private func getClosestCountryFromPosition() async {
        print("[MapViewModel] Calculating closest country from position.")
        guard !locatedCountryName.isEmpty else {
            return
        }
        
        var suggestedCoordinates = CLLocation()
        
        // If the user is located in an available country on the map.
        if annotationsViewModels.contains(where: { $0.countryName == locatedCountryName }), let viewModel = annotationsViewModels.first(where: { $0.countryName == locatedCountryName }) {
            print("[MapViewModel] Country already here: \(locatedCountryName)")
            suggestedCoordinates = CLLocation(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
            
            print("[MapViewModel] Actual: \(userMapPosition), suggested: \(suggestedCoordinates)")
            await showSuggestedLocationAlert(with: (userMapPosition, locatedCountryName), to: (suggestedCoordinates, locatedCountryName))
            
            return
        }
        
        // We use the actual location and we calculate the distance bettween the 2 countries
        var closestDistance = Double.infinity
        var suggestedCountry = ""
        
        annotationsViewModels.forEach { country in
            let coordinates = CLLocation(latitude: country.coordinates.latitude, longitude: country.coordinates.longitude)
            let distance = coordinates.distance(from: userMapPosition)
            
            if distance < closestDistance {
                closestDistance = distance
                suggestedCountry = country.countryName
                suggestedCoordinates = coordinates
                print("[MapViewModel] Closest country from \(locatedCountryName): \(country.countryName)")
            }
        }
        
        
        print("[MapViewModel] Country to suggest: \(suggestedCountry)")
        await showSuggestedLocationAlert(with: (userMapPosition, locatedCountryName), to: (suggestedCoordinates, suggestedCountry))
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func getAnnotationViewModels() -> [CountryAnnotationViewModel] {
        return annotationsViewModels
    }
}

extension MapViewModel {
    private func setBindings() {
        $searchQuery
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.searchCountry()
            }.store(in: &subscriptions)
    }
    
    private func searchCountry() {
        autocompletionViewModels.removeAll()
        
        guard !searchQuery.isEmpty else {
            autocompletionViewModels = annotationsViewModels
            updateResult.send(true)
            return
        }
        
        autocompletionViewModels = annotationsViewModels.filter { viewModel in
            viewModel.countryName.lowercased().contains(searchQuery.lowercased())
        }
        
        updateResult.send(true)
    }
    
    // In that case, it's a unique section TableView
    func numberOfRowsInTableView() -> Int {
        return autocompletionViewModels.count
    }
    
    func getAutoCompletionViewModel(at indexPath: IndexPath) -> CountryAnnotationViewModel? {
        // A TableView must have at least one section and one element on CellViewModels list, crash othervise
        let cellCount = autocompletionViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return autocompletionViewModels[indexPath.row]
    }
    
    func getUserMapPosition() -> CLLocation {
        return userMapPosition
    }
    
    func goToCountryNewsView(selectedCountryCode: String) {
        coordinator?.goToCountryNewsView(countryCode: selectedCountryCode)
    }
    
    @MainActor private func showSuggestedLocationAlert(with actualLocation: (location: CLLocation, countryName: String), to suggestedLocation: (location: CLLocation, countryName: String)) {
        coordinator?.displaySuggestedLocationAlert(with: actualLocation, to: suggestedLocation) { answer in
            print("[MapViewModel] Answer for centering: \(answer)")
            self.userLocation.send(answer ? suggestedLocation.location : actualLocation.location)
        }
    }
}
