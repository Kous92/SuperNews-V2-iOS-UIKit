//
//  ModuleBuilder.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/04/2023.
//

import Foundation
import UIKit

@MainActor protocol ModuleBuilder {
    func buildModule(testMode: Bool, coordinator: ParentCoordinator?) -> UIViewController
}
