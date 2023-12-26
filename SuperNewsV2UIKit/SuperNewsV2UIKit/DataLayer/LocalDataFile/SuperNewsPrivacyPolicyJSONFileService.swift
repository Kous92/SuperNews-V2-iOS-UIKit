//
//  SuperNewsPrivacyPolicyJSONFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/12/2023.
//

import Foundation

final class SuperNewsPrivacyPolicyJSONFileService: SuperNewsPrivacyPolicyLocalDataFileService {
    private func getFilePath(name: String) -> URL? {
        print("[SuperNewsPrivacyPolicyJSONFileService] Loading \(name).json...")
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("[SuperNewsPrivacyPolicyJSONFileService] The required file \(name).json is not available, cannot load data.")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        
        return nil
    }
    
    func loadPrivacyPolicy(userLanguage: String) async -> Result<PrivacyPolicy, SuperNewsLocalFileError> {
        guard let fileURL = getFilePath(name: "privacyPolicy\(userLanguage)") else {
            return .failure(.localFileError)
        }
        
        do {
            // Retrieving JSON data and converting to Data type
            let data = try Data(contentsOf: fileURL)
            
            // Decoding JSON data to Swift objects
            guard let privacyPolicy = decode(PrivacyPolicy.self, from: data) else {
                print("[SuperNewsPrivacyPolicyJSONFileService] Data decoding has failed.")
                return .failure(.decodeError)
            }
            
            print("[SuperNewsPrivacyPolicyJSONFileService] Privacy policy loaded.")
            return .success(privacyPolicy)
        } catch {
            print("[SuperNewsPrivacyPolicyJSONFileService] An error has occured: \(error)")
            return .failure(.decodeError)
        }
    }
}
