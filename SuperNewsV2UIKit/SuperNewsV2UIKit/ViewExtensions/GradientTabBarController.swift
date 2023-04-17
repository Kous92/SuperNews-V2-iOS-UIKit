//
//  GradientTabBarController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import UIKit

final class GradientTabBarController: UITabBarController {
    let layerGradient = CAGradientLayer()
    
    private func setLayerGradient() -> CAGradientLayer {
        let layerGradient = CAGradientLayer()
        let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
        let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
        
        layerGradient.colors = [
            blue,
            darkBlue,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        layerGradient.type = .axial
        layerGradient.locations = [0, 0.1, 0.3, 0.5, 1]
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
         
        return layerGradient
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.insertSublayer(setLayerGradient(), at: 0)
        
        // Apply for all views selected and unselected colors
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .darkGray
    }
}
