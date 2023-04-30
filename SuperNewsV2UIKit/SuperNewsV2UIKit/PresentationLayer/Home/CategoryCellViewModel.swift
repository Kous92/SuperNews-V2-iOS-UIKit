//
//  CategoryCellViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 26/04/2023.
//

import Foundation

final class CategoryCellViewModel {
    private(set) var title: String
    let categoryId: String
    
    init(title: String, categoryId: String) {
        self.title = title
        self.categoryId = categoryId
    }
    
    func setCategoryTitle(with title: String) {
        self.title = title
    }
}

extension CategoryCellViewModel {
    static func getCategories() -> [CategoryCellViewModel] {
        return [
            CategoryCellViewModel(title: "Actualités locales (France)", categoryId: "local"),
            CategoryCellViewModel(title: "Actualités d'une source", categoryId: "source"),
            CategoryCellViewModel(title: "Business", categoryId: "business"),
            CategoryCellViewModel(title: "Divertissement", categoryId: "entertainment"),
            CategoryCellViewModel(title: "Général", categoryId: "general"),
            CategoryCellViewModel(title: "Santé", categoryId: "health"),
            CategoryCellViewModel(title: "Science", categoryId: "science"),
            CategoryCellViewModel(title: "Sports", categoryId: "sports"),
            CategoryCellViewModel(title: "Technologie", categoryId: "technology")
        ]
    }
    
    static func getSourceCategories() -> [CategoryCellViewModel] {
        return [
            CategoryCellViewModel(title: "Toutes les sources", categoryId: "allSources"),
            CategoryCellViewModel(title: "Par langue", categoryId: "languageSources"),
            CategoryCellViewModel(title: "Par catégorie", categoryId: "categorySources"),
            CategoryCellViewModel(title: "Par pays", categoryId: "countrySources"),
        ]
    }
}
