//
//  ViewConstants.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 15/05/2023.
//

import Foundation
import UIKit

// Either on iPhone or iPad
@MainActor fileprivate func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

@MainActor struct Constants {
    @MainActor struct CategoryCollectionView {
        static let collectionViewHeight: CGFloat = isPhone() ? 60 : 90
        static let categoryTitleFontSize: CGFloat = isPhone() ? 17 : 24
        static let categoryTitleInsets: CGFloat = isPhone() ? 10 : 20
    }
    
    @MainActor struct TopHeadlines {
        static let noResultLabelFontSize: CGFloat = isPhone() ? 18 : 30
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
    }
    
    @MainActor struct Search {
        static let noResultLabelFontSize: CGFloat = isPhone() ? 18 : 30
    }
    
    @MainActor struct SourceSelection {
        static let noResultLabelFontSize: CGFloat = isPhone() ? 18 : 30
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let favoriteSelectedLabelFontSize: CGFloat = isPhone() ? 16 : 27
    }
    
    @MainActor struct ArticleDetail {
        static let stackViewHorizontalSpacing: CGFloat = isPhone() ? 8 : 16
        static let topImageHeight: CGFloat = isPhone() ? 250 : 450
        static let imageIconSize: CGFloat = isPhone() ? 20 : 32
        static let titleLabelFontSize: CGFloat = isPhone() ? 22 : 38
        static let stackLabelFontSize: CGFloat = isPhone() ? 20 : 32
        static let descriptionLabelFontSize: CGFloat = isPhone() ? 18 : 26
        static let contentLabelFontSize: CGFloat = isPhone() ? 15 : 23
        static let buttonTitleFontSize: CGFloat = isPhone() ? 18 : 30
        static let buttonHeight: CGFloat = isPhone() ? 50 : 85
        static let buttonInset: CGFloat = isPhone() ? 40 : 70
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let margin10: CGFloat = isPhone() ? 10 : 20
        static let margin30: CGFloat = isPhone() ? 30 : 60
    }
    
    @MainActor struct NewsCell {
        static let sourceLabelFontSize: CGFloat = isPhone() ? 14 : 26
        static let titleLabelFontSize: CGFloat = isPhone() ? 17 : 32
        static let imageInsets: CGFloat = isPhone() ? 10 : 25
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let bottomMargin: CGFloat = isPhone() ? 5 : 12
        static let imageCornerRadius: CGFloat = isPhone() ? 10 : 20
    }
    
    @MainActor struct SourceSelectionCell {
        static let viewCornerRadius: CGFloat = isPhone() ? 10 : 25
        static let viewInsets: CGFloat = isPhone() ? 10 : 25
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let margin10: CGFloat = isPhone() ? 10 : 20
        static let labelStackViewSpacing: CGFloat = isPhone() ? 10 : 20
        static let titleLabelFontSize: CGFloat = isPhone() ? 18 : 26
        static let descriptionLabelFontSize: CGFloat = isPhone() ? 15 : 22
        static let otherLabelFontSize: CGFloat = isPhone() ? 13 : 19
    }
    
    @MainActor struct MapView {
        static let cornerRadius: CGFloat = isPhone() ? 10 : 15
        static let buttonSize: CGFloat = isPhone() ? 50 : 75
        static let buttonSymbolSize: CGFloat = isPhone() ? 18 : 27
        static let buttonInset: CGFloat = isPhone() ? 15 : 30
        static let autoCompletionHeight: CGFloat = isPhone() ? 300 : 450
    }
    
    @MainActor struct PrivacyPolicy {
        static let titleLabelFontSize: CGFloat = isPhone() ? 22 : 34
        static let subtitleLabelFontSize: CGFloat = isPhone() ? 18 : 26
        static let descriptionFontSize: CGFloat = isPhone() ? 14 : 21
        static let dateLabelFontSize: CGFloat = isPhone() ? 15 : 22
        static let dateTopMargin: CGFloat = isPhone() ? 20 : 30
        static let dateBottomMargin: CGFloat = isPhone() ? 35 : 50
        static let subtitleOffset: CGFloat = isPhone() ? 15 : 25
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let topMargin: CGFloat = isPhone() ? 10 : 20
        static let bottomMargin: CGFloat = isPhone() ? 25 : 35
        static let lineSpacing: CGFloat = isPhone() ? 10 : 20
        
    }
}
