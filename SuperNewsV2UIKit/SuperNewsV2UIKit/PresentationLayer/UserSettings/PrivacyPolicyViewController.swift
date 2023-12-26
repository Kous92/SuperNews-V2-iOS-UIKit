//
//  PrivacyPolicyViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import UIKit
import Combine
import SnapKit

final class PrivacyPolicyViewController: UIViewController {
    // MVVM with Reactive Programming
    var viewModel: PrivacyPolicyViewModel?
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
        viewModel?.loadPrivacyPolicy()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "privacyPolicyCell")
        tableView.register(PrivacyHeaderTableViewCell.self, forCellReuseIdentifier: "privacyHeaderCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = "tableView"
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setBindings() {
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.updateTableView()
            }.store(in: &subscriptions)
    }
}

extension PrivacyPolicyViewController {
    private func setNavigationBar() {
        // Appearance of navigation bar
        let customNavBarAppearance = UINavigationBarAppearance()
        
        // In order to have the following title on next ViewController. Won't work otherwise if set directly on next ViewController
        navigationItem.backButtonTitle = String(localized: "back")
        navigationController?.navigationBar.tintColor = .white
        
        // When scrolling, custom color appareance for navigation bar
        customNavBarAppearance.backgroundColor = .superNewsMediumBlue.withAlphaComponent(0.95)
        
        // To avoid any color issue especially if we switch from dark to light mode. We want any NavigationBar title color kept at white.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func updateTableView() {
        print("[PrivacyPolicyViewController] Update TableView")
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension PrivacyPolicyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInTableView() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(),
              let identifier = viewModel?.getCellIdentifier(at: indexPath),
              let cell = PrivacyCellFactory.createCell(with: identifier, viewModel: cellViewModel, tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
         
        return cell
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PrivacyViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = PrivacyPolicyModuleBuilder()
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
