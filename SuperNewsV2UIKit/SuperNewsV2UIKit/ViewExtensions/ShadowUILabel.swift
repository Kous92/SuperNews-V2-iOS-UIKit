//
//  ShadowUILabel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import UIKit

extension UILabel {
    func setShadowLabel(string: String, font: UIFont, textColor: UIColor? = nil, shadowColor: UIColor? = nil, radius: CGFloat = 0) {        
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor ?? UIColor.black
        shadow.shadowBlurRadius = radius

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor ?? UIColor.white,
            .shadow: shadow
        ]
        
        self.attributedText = NSMutableAttributedString(string: string, attributes: attributes)
    }
}
