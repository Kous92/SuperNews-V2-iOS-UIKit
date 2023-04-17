//
//  GradientTabBarController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import UIKit

final class GradientTabBarController: UITabBarController {
    let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layerGradient.colors = [
            UIColor.blue.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        layerGradient.type = .axial
        layerGradient.locations = [0, 0.1, 0.3, 1]
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
         
        self.tabBar.layer.insertSublayer(layerGradient, at: 0)
        
        // Apply for all views selected and unselected colors
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .darkGray
    }
}
