//
//  ArticleDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import Foundation

/// Data Transfer Object as link between Data and Domain Layer
struct ArticleDTO {
    let author: String
    let title: String
    let description: String
    let content: String
    let sourceUrl: String
    let imageUrl: String
    let sourceName: String
    let publishedAt: String
    
    init(author: String, title: String, description: String, content: String, sourceUrl: String, imageUrl: String, sourceName: String, publishedAt: String) {
        self.author = author
        self.title = title
        self.description = description
        self.content = content
        self.sourceUrl = sourceUrl
        self.imageUrl = imageUrl
        self.sourceName = sourceName
        self.publishedAt = publishedAt
    }
    
    init(with article: Article) {
        self.author = article.author ?? "Auteur inconnu"
        self.title = article.title ?? "Titre indisponible"
        self.description = article.description ?? "Aucune description"
        self.content = article.content ?? "Aucun contenu disponible"
        self.sourceUrl = article.url ?? ""
        self.imageUrl = article.urlToImage ?? ""
        self.sourceName = article.source?.name ?? "Source inconnue"
        self.publishedAt = article.publishedAt ?? "Date inconnue"
    }
}
