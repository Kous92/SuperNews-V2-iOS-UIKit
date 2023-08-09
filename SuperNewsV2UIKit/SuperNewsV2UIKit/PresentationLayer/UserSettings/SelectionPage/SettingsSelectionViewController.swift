//
//  SettingsSelectionViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/08/2023.
//

import UIKit
import Combine
import SnapKit

final class SettingsSelectionViewController: UIViewController {
    // MVVM with Reactive Programming
    var viewModel: SettingsSelectionViewModel?
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountrySettingTableViewCell.self, forCellReuseIdentifier: "countrySettingCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewBackground()
        // setNavigationBar(with: "Langue et pays")
        buildViewHierarchy()
        setConstraints()
        setBindings()
        viewModel?.loadCountryLanguageOptions()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
        // Update binding
        viewModel?.settingOption
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.setNavigationBar(with: name)
            }.store(in: &subscriptions)
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                if updated {
                    self?.updateTableView()
                }
            }.store(in: &subscriptions)
    }
}

extension SettingsSelectionViewController {
    private func setNavigationBar(with name: String) {
        navigationItem.title = name
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func updateTableView() {
        print("Update TableView")
        tableView.reloadData()
    }
}

extension SettingsSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInTableView() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countrySettingCell", for: indexPath) as? CountrySettingTableViewCell,
              let countrySettingViewModel = viewModel?.getCellViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: countrySettingViewModel)
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // cell.textLabel?.text = "Paramètre \(indexPath.row)"
        // cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
}

extension SettingsSelectionViewController: UITableViewDelegate {
    
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SettingsSelectionViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = SettingsSelectionModuleBuilder(settingSection: SettingsSection.newsCountry)
                let vc = builder.buildModule(testMode: true)
                navigationController.pushViewController(vc, animated: false)
                return navigationController
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName): country mode")
            .edgesIgnoringSafeArea(.all)
            
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = SettingsSelectionModuleBuilder(settingSection: SettingsSection.newsLanguage)
                let vc = builder.buildModule(testMode: true)
                navigationController.pushViewController(vc, animated: false)
                return navigationController
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName): language mode")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
