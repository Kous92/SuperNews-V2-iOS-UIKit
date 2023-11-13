//
//  SearchViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import UIKit
import SnapKit
import Combine

final class SearchViewController: UIViewController {
    
    weak var coordinator: SearchViewControllerDelegate?
    
    // MVVM with Reactive Programming
    var viewModel: SearchViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    // Background
    lazy var backgroundGradient: CAGradientLayer = {
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.rowHeight = UIScreen.main.bounds.width * (9 / 16)
        tableView.estimatedRowHeight = UIScreen.main.bounds.width * (9 / 16)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = "tableView" // UI testing
        
        return tableView
    }()
    
    // For searching news
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = String(localized: "cancel")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        searchBar.accessibilityIdentifier = "searchBar"
        
        return searchBar
    }()
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.hidesWhenStopped = true
        
        return spinner
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
        label.accessibilityIdentifier = "noResultLabel"
        
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadAndUpdateUserLanguageSettingTitle()
        
        // In case of color mode switching (especially for world map)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
    
    private func buildViewHierarchy() {
        view.addSubview(loadingSpinner)
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func setConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.TopHeadlines.horizontalMargin)
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setBindings() {
        // Loading binding
        viewModel?.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.noResultLabel.isHidden = true
                    self?.setLoadingSpinner(isLoading: true)
                    self?.hideTableView()
                }
            }.store(in: &subscriptions)
        
        // Setting binding
        viewModel?.languageSettingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] languageName in
                self?.setSearchBar(languageName: languageName)
            }.store(in: &subscriptions)
        
        // Update binding
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                self?.loadingSpinner.stopAnimating()
                self?.setLoadingSpinner(isLoading: false)
                
                if updated {
                    self?.updateTableView()
                } else {
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
    }
}

extension SearchViewController {
    private func setNavigationBar() {        
        navigationItem.title = String(localized: "search")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setSearchBar(languageName: String) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "\(String(localized: "search")) (\(String(localized: "language")): \(languageName))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
    
    private func setViewBackground() {
        backgroundGradient.frame = view.bounds
        view.layer.addSublayer(backgroundGradient)
    }
    
    private func hideTableView() {
        tableView.isHidden = true
    }
    
    private func displayNoResult() {
        tableView.isHidden = true
        noResultLabel.text = "\(String(localized: "noResultFoundFor")) \"\(viewModel?.searchQuery ?? "??")\". \(String(localized: "pleaseTryOtherSearch"))."
        noResultLabel.isHidden = false
    }
    
    private func updateTableView() {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.isHidden = false
    }
    
    private func setLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInTableView() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? NewsTableViewCell, let cellViewModel = viewModel?.getNewsCellViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: cellViewModel)
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.goToArticleDetailView(selectedViewModelIndex: indexPath.row)
    }
}

extension SearchViewController: UISearchBarDelegate {
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
struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let tabBar = GradientTabBarController()
                let navigationController = UINavigationController()
                let builder = SearchModuleBuilder()
                let vc = builder.buildModule(testMode: true)
                vc.tabBarItem = UITabBarItem(title: String(localized: "news"), image: UIImage(systemName: "newspaper"), tag: 0)
                navigationController.pushViewController(vc, animated: false)
                tabBar.viewControllers = [navigationController]
                
                return tabBar
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.light)
            .previewDisplayName(deviceName)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
