//
//  Article.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import Foundation

// MARK: Response
struct ArticleOutput: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
    let code: String?
    let message: String?
}

// MARK: - Article
struct Article: Codable {
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source of the article
struct ArticleSource: Codable {
    let id: String?
    let name: String?
}

extension Article {
    /// Returns a fake object with all available fields, not nil case. For unit tests and SwiftUI previews
    static func getFakeArticle() -> Article {
        return Article(
            source: ArticleSource(id: "mac-rumors", name: "MacRumors"),
            author: "Joe Rossignol",
            title: "iOS 16.4 Expands iPhone 14's Emergency SOS via Satellite to Six More Countries",
            description: "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 update released today to function in these countries.\n\n\n\n\n\nEmer…",
            url: "https://www.macrumors.com/2023/03/27/emergency-sos-via-satellite-six-more-countries/",
            urlToImage: "https://images.macrumors.com/t/NiqVm75fJdfBoWGMCBRbMJjPAU0=/3564x/article-new/2022/11/Emergency-SOS-via-Satellite-iPhone-YT.jpg",
            publishedAt: "2023-03-27T17:33:52Z",
            content: "As planned, Apple today epanded Emergency SOS via Satellite to Austria, Belgium, Italy, Luxembourg, the Netherlands, and Portugal. In a press release, Apple said the feature requires the iOS 16.4 upd… [+958 chars]"
        )
    }
    
    /// Returns a fake object with some unavailable fields.
    static func getFakeArticleWithNilContent() -> Article {
        return Article(
            source: ArticleSource(id: nil, name: "Google News"),
            author: "Pure People",
            title: "Hervé Temime, grand maître du barreau : les causes de sa mort à seulement 65 ans révélées - Pure People",
            description: nil,
            url: "https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy5wdXJlcGVvcGxlLmNvbS9hcnRpY2xlL2hlcnZlLXRlbWltZS1ncmFuZC1tYWl0cmUtZHUtYmFycmVhdS1sZXMtY2F1c2VzLWRlLXNhLW1vcnQtYS1zZXVsZW1lbnQtNjUtYW5zLXJldmVsZWVzX2E1MDcxNjkvMdIBAA?oc=5",
            urlToImage: nil,
            publishedAt: "2023-03-27T17:33:52Z",
            content: nil
        )
    }
}
