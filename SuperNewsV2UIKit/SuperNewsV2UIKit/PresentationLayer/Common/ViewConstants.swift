//
//  ViewConstants.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 15/05/2023.
//

import Foundation
import UIKit

// Either on iPhone or iPad
fileprivate func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

struct Constants {
    struct CategoryCollectionView {
        static let collectionViewHeight: CGFloat = isPhone() ? 50 : 90
        static let categoryTitleFontSize: CGFloat = isPhone() ? 17 : 24
        static let categoryTitleInsets: CGFloat = isPhone() ? 10 : 20
    }
    
    struct TopHeadlines {
        static let noResultLabelFontSize: CGFloat = isPhone() ? 18 : 30
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
    }
    
    struct SourceSelection {
        static let noResultLabelFontSize: CGFloat = isPhone() ? 18 : 30
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
    }
    
    struct ArticleDetail {
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
    
    struct NewsCell {
        static let sourceLabelFontSize: CGFloat = isPhone() ? 14 : 26
        static let titleLabelFontSize: CGFloat = isPhone() ? 17 : 32
        static let imageInsets: CGFloat = isPhone() ? 10 : 25
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let bottomMargin: CGFloat = isPhone() ? 5 : 12
        static let imageCornerRadius: CGFloat = isPhone() ? 10 : 20
    }
    
    struct SourceSelectionCell {
        static let viewCornerRadius: CGFloat = isPhone() ? 10 : 25
        static let viewInsets: CGFloat = isPhone() ? 10 : 25
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let margin10: CGFloat = isPhone() ? 10 : 20
        static let labelStackViewSpacing: CGFloat = isPhone() ? 10 : 20
        static let titleLabelFontSize: CGFloat = isPhone() ? 18 : 26
        static let descriptionLabelFontSize: CGFloat = isPhone() ? 15 : 22
        static let otherLabelFontSize: CGFloat = isPhone() ? 13 : 19
    }
}
