//
//  SuperNewsGPSLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation
@preconcurrency import AsyncLocationKit

final class SuperNewsGPSLocationService: NSObject, SuperNewsLocationService {
    private let asyncLocationManager = AsyncLocationManager(desiredAccuracy: .bestAccuracy)
    
    override init() {
        print("[SuperNewsGPSLocationService] Starting")
    }
    
    private func checkLocationPermission() -> Result<Void, SuperNewsGPSError> {
        print("[SuperNewsGPSLocationService] Checking user location permission.")
        let authorizationStatus = asyncLocationManager.getAuthorizationStatus()
        
        switch authorizationStatus {
            case .notDetermined:
                return .failure(.serviceNotAvailable)
            case .restricted:
                print("[SuperNewsGPSLocationService] Location service is restricted by parental control.")
                return .failure(.restricted)
            case .denied:
                print("Vous avez refusé l'accès au service de localisation. Merci de l'autoriser en allant dans Réglages > Confidentialité > Service de localisation > SuperNews.")
                return .failure(.denied)
            case .authorizedAlways, .authorizedWhenInUse:
                print("[SuperNewsGPSLocationService] OK: permission is granted")
                return .success(())
            @unknown default:
                return .failure(.serviceNotAvailable)
        }
    }
    
    func fetchLocation() async throws -> CLLocation {
        print("[SuperNewsGPSLocationService] Fetching user location. Thread \(Thread.currentThread)")
        let permission = checkLocationPermission()
        
        switch permission {
            case .success(_):
                break
            case .failure(_):
                let authorization = await asyncLocationManager.requestPermission(with: .whenInUsage)
                print(authorization)
        }
        
        for await locationUpdateEvent in await asyncLocationManager.startUpdatingLocation() {
            switch locationUpdateEvent {
                case .didUpdateLocations(let locations):
                    asyncLocationManager.stopUpdatingLocation()
                    
                    guard let location = locations.last else {
                        throw SuperNewsGPSError.unknown
                    }
                    
                    print("[SuperNewsGPSLocationService] User location retrieved: \(location)")
                    return location
                case .didFailWith(let error):
                    print(error.localizedDescription)
                    break
                case .didPaused, .didResume:
                    break
            }
        }
        
        throw SuperNewsGPSError.serviceNotAvailable
    }
    
    func reverseGeocoding(location: CLLocation) async throws -> String {
        print("[SuperNewsGPSLocationService] Reverse geocoding. Thread \(Thread.currentThread)")
        do {
            let geocoder: CLGeocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.current)
            
            guard let place = placemarks.first, let countryName = place.country else {
                throw SuperNewsGPSError.reverseGeocodingFailed
            }
            
            return countryName
        } catch {
            print(error.localizedDescription)
            throw SuperNewsGPSError.reverseGeocodingFailed
        }
    }
}
