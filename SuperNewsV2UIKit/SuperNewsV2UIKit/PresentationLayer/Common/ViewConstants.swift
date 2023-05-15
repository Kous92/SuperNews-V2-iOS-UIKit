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
    
    struct HappyNewYearAnimation {
        static let happyNewYearFontSize: CGFloat = isPhone() ? 50 : 100
        static let yearFontSize: CGFloat = isPhone() ? 90 : 160
        static let messageFontSize: CGFloat = isPhone() ? 30 : 50
        static let messageYposition: CGFloat = isPhone() ? 80 : 120
    }
}
