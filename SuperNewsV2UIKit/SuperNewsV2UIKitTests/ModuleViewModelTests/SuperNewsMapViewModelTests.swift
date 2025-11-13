//
//  SuperNewsMapViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 12/07/2023.
//

import XCTest
import Combine
import CoreLocation
@testable import SuperNewsV2UIKit

@MainActor final class SuperNewsMapViewModelTests: XCTestCase {

    var subscriptions: Set<AnyCancellable> = []
    var viewModel: MapViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let locationRepository = SuperNewsGPSRepository(locationService: SuperNewsMockLocationService(forceFetchFailure: false))
        let localFileRepository = SuperNewsJSONFileRepository(localFileService: SuperNewsMockFileService(forceLoadFailure: false))
        let mapUseCase = MapUseCase(localFileRepository: localFileRepository)
        let fetchUserLocationUseCase = FetchUserLocationUseCase(locationRepository: locationRepository)
        let reverseGeocodingUseCase = ReverseGeocodingUseCase(locationRepository: locationRepository)
        viewModel = MapViewModel(mapUseCase: mapUseCase, fetchUserLocationUseCase: fetchUserLocationUseCase, reverseGeocodingUseCase: reverseGeocodingUseCase)
        
        viewModel?.loadCountries()
    }
    
    func testGetLocation() {
        let expectation1 = XCTestExpectation(description: "Get user location")
        var userLocation = CLLocationCoordinate2D()
        
        viewModel?.userLocationPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                XCTFail()
            } receiveValue: { location in
                print("[SuperNewsMapViewModelTests] Location succeeded, fulfilled")
                expectation1.fulfill()
                userLocation = location.coordinate
            }.store(in: &subscriptions)
        
        viewModel?.getLocation()

        wait(for: [expectation1], timeout: 10)
        XCTAssertEqual(userLocation.latitude, 2.301540063286635)
        XCTAssertEqual(userLocation.longitude, 48.87255175759405)
    }
    
    func testLoadCountries() {
        let expectation2 = XCTestExpectation(description: "Load countries from local file")
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                if updated {
                    print("Fulfilled")
                    expectation2.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [expectation2], timeout: 10)
        XCTAssertGreaterThan(viewModel?.getAnnotationViewModels().count ?? 0, 0)
    }
}
