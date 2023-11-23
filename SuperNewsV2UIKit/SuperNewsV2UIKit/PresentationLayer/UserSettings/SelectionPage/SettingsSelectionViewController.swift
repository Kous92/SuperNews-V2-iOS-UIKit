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
        tableView.accessibilityIdentifier = "settingsChoiceTable"
        // tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = String(localized: "cancel")
        searchBar.accessibilityIdentifier = "searchBar"
        
        return searchBar
    }()
    
    private lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.setShadowLabel(string: String(localized: "noArticleAvailable"), font: UIFont.systemFont(ofSize: Constants.TopHeadlines.noResultLabelFontSize, weight: .medium), textColor: .white, shadowColor: .blue, radius: 3)
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
        setBindings()
        viewModel?.loadCountryLanguageOptions()
    }
    
    // Will not work before in cycle (viewDidLoad,...)
    override func viewWillAppear(_ animated: Bool) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: String(localized: "search"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        // In case of color mode switching (especially for world map)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    // WARNING: This function is triggered when the screen is destroyed and when a screen will go above this one.
    override func viewWillDisappear(_ animated: Bool) {
        // We make sure to avoid any memory leak by destroying correctly the coordinator instance. Popping ViewController is already done with NavigationController, no need to add extra instruction.
        if isMovingFromParent {
            viewModel?.backToPreviousScreen()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func buildViewHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.TopHeadlines.horizontalMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setBindings() {
        // Update binding
        viewModel?.settingOptionResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.setNavigationBar(with: name)
            }.store(in: &subscriptions)
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                if updated {
                    self?.updateTableView()
                } else {
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
    }
}

extension SettingsSelectionViewController {
    private func setNavigationBar(with name: String) {
        navigationItem.title = name
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func updateTableView() {
        noResultLabel.isHidden = true
        print("[SettingsSelectionViewController] Update TableView")
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    private func displayNoResult() {
        tableView.isHidden = true
        noResultLabel.text = "\"\(viewModel?.searchQuery ?? "??")\" \(String(localized: "doesNotExist")) \(String(localized: "pleaseTryOtherSearch"))."
        noResultLabel.isHidden = false
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
        
        if countrySettingViewModel.isSaved == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.tintColor = .green
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
}

extension SettingsSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[SettingsSelectionViewController] Selected row \(indexPath.row)")
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selected = indexPath.row
        let actualSelectedIndex = viewModel?.getActualSelectedIndex() ?? 0
        print(actualSelectedIndex)
        
        // Did the user tap on a selected filter item? If so, do nothing.
        if selected == actualSelectedIndex {
            return
        }
        
        // Remove the checkmark from the previously selected filter item.
        if let previousCell = tableView.cellForRow(at: IndexPath(row: actualSelectedIndex, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }
        
        // Mark the newly selected filter item with a checkmark.
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        viewModel?.saveSelectedSetting(at: indexPath)
    }
}

extension SettingsSelectionViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchQuery = ""
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
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
