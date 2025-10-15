//
//  TabBarFactory.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 28/09/2025.
//

import Foundation
import UIKit

@MainActor final class TabBarCellFactory {
    static func getTabBar() -> UITabBarController {
        if #available(iOS 26.0, *) {
            return LiquidGlassTabBarController()
        } else {
            return GradientTabBarController()
        }
    }
}
