//
//  GradientView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 07/06/2023.
//

import UIKit

// Works best if it's used in didLayoutSubviews method to apply the view background gradient.
extension UIView {
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil, cornerRadius: 0)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, cornerRadius: CGFloat) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius
        gradient.type = .axial
        self.layer.insertSublayer(gradient, at: 0)
    }
}

