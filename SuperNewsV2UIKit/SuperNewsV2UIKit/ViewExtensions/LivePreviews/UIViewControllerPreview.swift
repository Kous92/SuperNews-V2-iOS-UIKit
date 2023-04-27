//
//  UIViewControllerPreview.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/// 3 useful formats to see how it renders on different iOS/iPadOS devices. Make sure your Xcode version have the devices with the corresponding name in your simulators list
let deviceNames: [String] = [
    "iPhone 14 Pro",
    "iPhone SE (3rd generation)",
    "iPad Pro (11-inch) (4th generation)"
]

/// It allows to live preview a UIViewController made with UIKit with same SwiftUI preview method. Very helpful to save time when making the view (programmatically), to avoir also building every time to check how it looks.
@available(iOS 13, *)
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif
