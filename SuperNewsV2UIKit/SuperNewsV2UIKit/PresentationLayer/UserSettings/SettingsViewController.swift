//
//  SettingsViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 14/07/2023.
//

import UIKit
import SnapKit
import Combine

final class SettingsViewController: UIViewController {
    
    // MVVM with Reactive Programming
    var viewModel: SettingsViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var gradient: CAGradientLayer = {
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewBackground()
        setNavigationBar()
        buildViewHierarchy()
        setConstraints()
        setBindings()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func buildViewHierarchy() {
        
    }
    
    private func setConstraints() {
        
    }
    
    private func setBindings() {
        
    }
}

extension SettingsViewController {
    private func setNavigationBar() {
        navigationItem.title = "Paramètres"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SettingsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = SettingsModuleBuilder()
                let vc = builder.buildModule(testMode: true)
                navigationController.pushViewController(vc, animated: false)
                return navigationController
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName(deviceName)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
