//
//  Coordinator.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start() -> UIViewController
    var childCoordinators: [Coordinator] { get set }
    
    func addChildCoordinator(childCoordinator: Coordinator)
    func removeChildCoordinator(childCoordinator: Coordinator)
}

extension Coordinator {
    /// Adds a child coordinator to the parent, the parent will have a reference to the child one.
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }

    /// Removes a child coordinator from the parent.
    func removeChildCoordinator(childCoordinator: Coordinator) {
        print("Removing child coordinator")
        // Make sure to check reference between coordinators, use === instead of ==.
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

protocol ParentCoordinator: Coordinator, AnyObject {
    var parentCoordinator: Coordinator? { get }
    var navigationController: UINavigationController { get }
}
