//
//  SuperNewsUserDefaultsLocalSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/05/2023.
//

import Foundation

final class SuperNewsUserDefaultsLocalSettings: SuperNewsLocalSettings {
    func saveSelectedMediaSource(source: SavedSource) async -> Result<Void, SuperNewsLocalSettingsError> {
        print("Saving selected source: \(source.name), id: \(source.id)")
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode saved source
            let data = try encoder.encode(source)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "savedSource")
            
            // Done, notify that saving has succeeded
            return .success(())

        } catch {
            print("ERROR: Unable to encode the selected source to save (\(error))")
            return .failure(.encodeError)
        }
    }
    
    func loadSelectedMediaSource() async -> Result<SavedSource, SuperNewsLocalSettingsError> {
        print("Loading selected source")
        
        if let data = UserDefaults.standard.data(forKey: "savedSource") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let savedSource = try decoder.decode(SavedSource.self, from: data)
                
                // Done, notify that loading has succeeded
                return .success(savedSource)
            } catch {
                print("ERROR: Unable to decode the loaded source (\(error))")
                return .failure(.decodeError)
            }
        }
        
        return .failure(.localSettingsError)
    }
}
