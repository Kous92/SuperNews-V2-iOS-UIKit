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
    
    private var userMapPosition = CLLocation()
    
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
                    self.userLocation.send(userCoordinates)
                    self.userMapPosition = userCoordinates
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
}
