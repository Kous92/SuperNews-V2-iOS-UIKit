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

func getGradient1() -> CAGradientLayer {
    let gradient = CAGradientLayer()
    let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
    let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
    gradient.type = .axial
    gradient.colors = [
        blue,
        darkBlue,
        darkBlue,
        UIColor.black.cgColor
    ]
    gradient.locations = [0, 0.25, 0.5, 1]
    return gradient
}

func getGradient2() -> CAGradientLayer {
    let gradient = CAGradientLayer()
    let brightBlue = UIColor(resource: .superNewsBrightBlue).cgColor
    let blue = UIColor(resource: .superNewsBlue).cgColor
    let mediumBlue = UIColor(resource: .superNewsMediumBlue).cgColor
    let darkBlue = UIColor(resource: .superNewsDarkBlue).cgColor
    gradient.type = .axial
    gradient.colors = [
        brightBlue,
        blue,
        mediumBlue,
        darkBlue
    ]
    gradient.locations = [0, 0.15, 0.4, 1]
    return gradient
}
