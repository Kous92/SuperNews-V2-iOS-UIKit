//
//  GradientUIButton.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 15/05/2023.
//

import UIKit

extension UIButton {
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = 10
        self.layer.insertSublayer(gradient, at: 0)
    }
}
