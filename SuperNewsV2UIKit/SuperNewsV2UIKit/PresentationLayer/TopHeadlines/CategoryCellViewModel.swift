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
            CategoryCellViewModel(title: String(localized: "localNews"), categoryId: "local"),
            CategoryCellViewModel(title: String(localized: "sourceNews"), categoryId: "source"),
            CategoryCellViewModel(title: String(localized: "business"), categoryId: "business"),
            CategoryCellViewModel(title: String(localized: "entertainment"), categoryId: "entertainment"),
            CategoryCellViewModel(title: String(localized: "general"), categoryId: "general"),
            CategoryCellViewModel(title: String(localized: "health"), categoryId: "health"),
            CategoryCellViewModel(title: String(localized: "science"), categoryId: "science"),
            CategoryCellViewModel(title: String(localized: "sports"), categoryId: "sports"),
            CategoryCellViewModel(title: String(localized: "technology"), categoryId: "technology")
        ]
    }
    
    static func getSourceCategories() -> [CategoryCellViewModel] {
        return [
            CategoryCellViewModel(title: String(localized: "allSources"), categoryId: "allSources"),
            CategoryCellViewModel(title: String(localized: "byLanguage"), categoryId: "languageSources"),
            CategoryCellViewModel(title: String(localized: "byCategory"), categoryId: "categorySources"),
            CategoryCellViewModel(title: String(localized: "byCountry"), categoryId: "countrySources"),
        ]
    }
}
