//
//  CategoryCellViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 26/04/2023.
//

import Foundation

struct CategoryCellViewModel {
    let title: String
    let categoryId: String
    
    init(title: String, categoryId: String) {
        self.title = title
        self.categoryId = categoryId
    }
}

extension CategoryCellViewModel {
    static func getCategories() -> [CategoryCellViewModel] {
        return [
            CategoryCellViewModel(title: "Actualités locales (France)", categoryId: "local"),
            CategoryCellViewModel(title: "Business", categoryId: "business"),
            CategoryCellViewModel(title: "Divertissement", categoryId: "entertainment"),
            CategoryCellViewModel(title: "Général", categoryId: "general"),
            CategoryCellViewModel(title: "Santé", categoryId: "health"),
            CategoryCellViewModel(title: "Science", categoryId: "science"),
            CategoryCellViewModel(title: "Sports", categoryId: "sports"),
            CategoryCellViewModel(title: "Technologie", categoryId: "technology")
        ]
    }
}
