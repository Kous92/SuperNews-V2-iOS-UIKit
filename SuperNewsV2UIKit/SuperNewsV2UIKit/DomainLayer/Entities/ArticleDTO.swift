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
    
    init(with article: Article) {
        self.author = article.author ?? String(localized: "unknownAuthor")
        self.title = article.title ?? String(localized: "noTitle")
        self.description = article.description ?? String(localized: "noDescription")
        self.content = article.content ?? String(localized: "noAvailableContent")
        self.sourceUrl = article.url ?? ""
        self.imageUrl = article.urlToImage ?? ""
        self.sourceName = article.source?.name ?? String(localized: "unknownSource")
        self.publishedAt = article.publishedAt ?? String(localized: "unknownDate")
    }
}

extension ArticleDTO {
    static func getFakeObjectFromArticle() -> ArticleDTO {
        return ArticleDTO(with: Article.getFakeArticle())
    }
}
