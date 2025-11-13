//
//  SuperNewsMockLocalSettings.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/05/2023.
//

import Foundation

final actor SuperNewsMockLocalSettings: SuperNewsLocalSettings {
    private var savedData: Data?
    
    init() {
        print("[SuperNewsMockLocalSettings] Starting mock Local Settings")
    }
    
    func saveSelectedMediaSource(source: SavedSource) async -> Result<Void, SuperNewsLocalSettingsError> {
        print("[SuperNewsMockLocalSettings] Saving selected source: \(source.name), id: \(source.id)")
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode saved source
            let data = try encoder.encode(source)

            // Write/Set Data
            savedData = data
            
            // Done, notify that saving has succeeded
            return .success(())

        } catch {
            print("[SuperNewsMockLocalSettings] ERROR: Unable to encode the selected source to save (\(error))")
            return .failure(.encodeError)
        }
    }
    
    func loadSelectedMediaSource() async -> Result<SavedSource, SuperNewsLocalSettingsError> {
        print("[SuperNewsMockLocalSettings] Loading selected source")
        
        if let data = savedData {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Source
                let savedSource = try decoder.decode(SavedSource.self, from: data)
                
                // Done, notify that loading has succeeded
                return .success(savedSource)
            } catch {
                print("[SuperNewsMockLocalSettings] ERROR: Unable to decode the loaded source (\(error))")
                return .failure(.decodeError)
            }
        }
        
        return .failure(.localSettingsError)
    }
}
