//
//  LiquidGlassTabBarController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 28/09/2025.
//

import UIKit

final class LiquidGlassTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tabBar.layer.insertSublayer(setLayerGradient(), at: 0)
        
        // Apply for all views selected and unselected colors
        UITabBar.appearance().tintColor = .white
    }
}
