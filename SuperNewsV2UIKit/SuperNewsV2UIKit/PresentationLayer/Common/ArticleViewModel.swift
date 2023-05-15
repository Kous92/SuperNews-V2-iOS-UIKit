//
//  ArticleViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import Foundation

struct ArticleViewModel {
    let author: String
    let title: String
    let description: String
    let content: String
    let sourceUrl: String
    let imageUrl: String
    let sourceName: String
    let publishedAt: String
    
    init(with article: ArticleDTO) {
        self.author = article.author
        self.title = article.title
        self.description = article.description
        self.content = article.content
        self.sourceUrl = article.sourceUrl
        self.imageUrl = article.imageUrl
        self.sourceName = article.sourceName
        self.publishedAt = article.publishedAt.stringToDateFormat()
    }
    
    func getNewsCellViewModel() -> NewsCellViewModel {
        return NewsCellViewModel(imageURL: self.imageUrl, title: self.title, source: self.sourceName)
    }
}
