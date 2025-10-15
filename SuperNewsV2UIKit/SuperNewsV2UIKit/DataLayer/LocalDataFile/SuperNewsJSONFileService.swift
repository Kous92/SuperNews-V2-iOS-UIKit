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
    
    func loadCountries() async throws -> [Country] {
        guard let fileURL = getFilePath(name: "countries") else {
            throw SuperNewsLocalFileError.localFileError
        }
        
        do {
            // Retrieving JSON data and converting to Data type
            let data = try Data(contentsOf: fileURL)
            
            // Decoding JSON data to Swift objects
            guard let countries = decode([Country].self, from: data) else {
                print("[SuperNewsJSONFileService] Data decoding has failed.")
                throw SuperNewsLocalFileError.decodeError
            }
            
            print("[SuperNewsJSONFileService] \(countries.count) countries loaded.")
            return countries
        } catch {
            print("[SuperNewsJSONFileService] An error has occured: \(error)")
            throw SuperNewsLocalFileError.decodeError
        }
    }
    
    func loadLanguages() async throws -> [Language] {
        guard let fileURL = getFilePath(name: "languages") else {
            throw SuperNewsLocalFileError.localFileError
        }
        
        do {
            // Retrieving JSON data and converting to Data type
            let data = try Data(contentsOf: fileURL)
            
            // Decoding JSON data to Swift objects
            guard let languages = decode([Language].self, from: data) else {
                print("[SuperNewsJSONFileService] Data decoding has failed.")
                throw SuperNewsLocalFileError.decodeError
            }
            
            print("[SuperNewsJSONFileService] \(languages.count) languages loaded.")
            return languages
        } catch {
            print("[SuperNewsJSONFileService] An error has occured: \(error)")
            throw SuperNewsLocalFileError.decodeError
        }
    }
}
