//
//  ShadowUILabel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import UIKit

extension UILabel {
    func setShadowLabel(color: CGColor? = nil, opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = CGSize(width: 0, height: 0)) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
}
