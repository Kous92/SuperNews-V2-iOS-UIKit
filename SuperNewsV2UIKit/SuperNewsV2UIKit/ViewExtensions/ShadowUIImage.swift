//
//  ShadowUIImage.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import Foundation
import UIKit

extension UIView {
    /// Draws a shadow around the view. Make sure that the view is already drawn before drawing efficiently the shadow with shadow path.
    func setViewShadow(color: CGColor = UIColor.black.cgColor, offset: CGSize, radius: CGFloat, opacity: Float, boundsToDrawShadowPath: CGRect, cornerRadius: CGFloat) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = UIBezierPath(roundedRect: boundsToDrawShadowPath, cornerRadius: cornerRadius).cgPath
    }
}
