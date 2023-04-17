//
//  SearchViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import UIKit

final class SearchViewController: UIViewController {

    weak var coordinator: SearchViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        // Do any additional setup after loading the view.
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {

        // Dark mode
        UIViewControllerPreview {
            let vc = SearchViewController()
            return vc
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        .preferredColorScheme(.dark)
        .previewDisplayName("iPhone 14 Pro")
        .edgesIgnoringSafeArea(.all)
    }
}
#endif
