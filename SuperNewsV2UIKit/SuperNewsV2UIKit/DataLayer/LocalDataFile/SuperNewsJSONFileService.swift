//
//  SuperNewsJSONFileService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

final class SuperNewsJSONFileService: SuperNewsLocalDataFileService {
    private func getFilePath(name: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("[SuperNewsJSONFileService] The required file \(name).json is not available, cannot load data.")
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
    
    func loadCountries() async -> Result<[Country], SuperNewsLocalFileError> {
        guard let fileURL = getFilePath(name: "countries") else {
            return .failure(.localFileError)
        }
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            guard let countries = decode([Country].self, from: data) else {
                print("[SuperNewsJSONFileService] Data decoding has failed.")
                return .failure(.decodeError)
            }
            
            print("[SuperNewsJSONFileService] \(countries.count) countries loaded.")
            return .success(countries)
        } catch {
            print("[SuperNewsJSONFileService] An error has occured: \(error)")
            return .failure(.decodeError)
        }
    }
}
