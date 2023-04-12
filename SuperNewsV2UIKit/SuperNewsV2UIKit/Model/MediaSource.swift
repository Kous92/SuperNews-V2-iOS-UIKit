//
//  MediaSource.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import Foundation

struct MediaSourceOutput: Decodable {
    let status: String
    let sources: [MediaSource]
}

struct MediaSource: Decodable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}

extension MediaSource {
    static func getFakeObject() -> MediaSource {
        return MediaSource(id: "le-monde", name: "Le Monde", description: "Les articles du journal et toute l'actualité; en continu : International, France, Société, Économie, Culture, Environnement, Blogs ...", url: "http://www.lemonde.fr", category: "general", language: "fr", country: "fr")
    }
}
