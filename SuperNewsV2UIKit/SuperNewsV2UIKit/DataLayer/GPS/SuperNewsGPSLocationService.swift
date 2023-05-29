//
//  SuperNewsGPSLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation
import AsyncLocationKit

final class SuperNewsGPSLocationService: NSObject, SuperNewsLocationService {
    private var geocoder: CLGeocoder = CLGeocoder()
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
    
    func fetchLocation() async -> Result<CLLocation, SuperNewsGPSError> {
        print("[SuperNewsGPSLocationService] Fetching user location")
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
                        return .failure(.unknown)
                    }
                    
                    print("[SuperNewsGPSLocationService] User location retrieved: \(location)")
                    return .success(location)
                case .didFailWith(let error):
                    print(error.localizedDescription)
                    break
                case .didPaused, .didResume:
                    break
            }
        }
        
        return .failure(.serviceNotAvailable)
    }
    
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError> {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "fr_FR"))
            
            guard let place = placemarks.first, let countryName = place.country else {
                return .failure(.reverseGeocodingFailed)
            }
            
            return .success(countryName)
        } catch {
            print(error.localizedDescription)
            return .failure(.reverseGeocodingFailed)
        }
    }
}
