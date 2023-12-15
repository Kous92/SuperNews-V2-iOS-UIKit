//
//  SourceSelectionViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import UIKit
import SnapKit
import Combine

final class SourceSelectionViewController: UIViewController {
    
    // MVVM with Reactive Programming
    var viewModel: SourceSelectionViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
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
        label.isHidden = true
        label.accessibilityIdentifier = "noResultLabel"
        
        return label
    }()
    
    private lazy var actualFavoriteSourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        // label.isHidden = true
        label.text = "Source favorite sélectionnée"
        label.accessibilityIdentifier = "actualFavoriteResultLabel"
        
        return label
    }()
    
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
    
    // For filtering
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = String(localized: "search")
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = String(localized: "cancel")
        searchBar.accessibilityIdentifier = "searchBar"
        
        return searchBar
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.accessibilityIdentifier = "collectionView"
        
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: "sourceCell")
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = "tableView"
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewBackground()
        setNavigationBar()
        buildViewHierarchy()
        setConstraints()
        setBindings()
        
        viewModel?.loadSelectedSource()
    }
    
    // Will not work before in cycle (viewDidLoad,...)
    override func viewWillAppear(_ animated: Bool) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: String(localized: "search"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        // In case of color mode switching (especially for world map)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
        // When the screen is loaded, the first category is selected, only once.
        categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // WARNING: This function is triggered when the screen is destroyed and when a screen will go above this one.
    override func viewWillDisappear(_ animated: Bool) {
        // We make sure it will go back to previous view
        if isMovingFromParent {
            viewModel?.backToTopHeadlinesView()
        }
    }

    private func buildViewHierarchy() {
        view.addSubview(loadingSpinner)
        view.addSubview(noResultLabel)
        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(actualFavoriteSourceLabel)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.SourceSelection.horizontalMargin)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constants.CategoryCollectionView.collectionViewHeight)
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(categoryCollectionView.snp.bottom)
        }
        
        actualFavoriteSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            // make.bottom.equalTo(tableView.snp.top)
            // make.verticalEdges.equalTo(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(actualFavoriteSourceLabel.snp.bottom).offset(15)
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
        
        viewModel?.favoriteSourceUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] sourceName in
                self?.updateFavoriteSourceLabel(sourceName: sourceName)
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
                    print("No result")
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
        
        // Update after sorting
        viewModel?.sortedUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in

                self?.loadingSpinner.stopAnimating()
                self?.setLoadingSpinner(isLoading: false)
                
                if updated {
                    self?.updateTableView()
                } else {
                    print("No result")
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
    }
}

extension SourceSelectionViewController {
    private func setNavigationBar() {
        navigationItem.title = String(localized: "allSources")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func hideTableView() {
        tableView.isHidden = true
    }
    
    private func displayNoResult() {
        print("No result")
        tableView.isHidden = true
        noResultLabel.setShadowLabel(string: "\(String(localized: "noSourceFound")) \(viewModel?.searchQuery ?? "??")", font: UIFont.systemFont(ofSize: 18, weight: .medium), textColor: .white, shadowColor: .blue, radius: 3)
        noResultLabel.isHidden = false
    }
    
    private func updateTableView() {
        print("Update TableView")
        tableView.reloadData()
        
        // To avoid some crashes
        if let titles = viewModel?.filteredSectionViewModels.map({ $0.sectionName }), titles.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        tableView.isHidden = false
    }
    
    private func updateFavoriteSourceLabel(sourceName: String) {
        actualFavoriteSourceLabel.text = "\(String(localized: "favoriteSelectedSource")): \(sourceName)"
    }
    
    private func setLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
    }
}

extension SourceSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInCollectionView() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell, let cellViewModel = viewModel?.getCategoryCellViewModel(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cellViewModel.title)
        
        return cell
    }
}

extension SourceSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard let cellViewModel = viewModel?.getCategoryCellViewModel(at: indexPath) else {
            return
        }
        
        viewModel?.setSourceOption(with: cellViewModel.categoryId)
    }
}

extension SourceSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(sectionIndex: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as? SourceTableViewCell,
              let cellViewModel = viewModel?.getCellViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: cellViewModel)
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.tintColor = .superNewsDarkGray
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.getSectionHeaderTitle(sectionIndex: section)
    }
}

extension SourceSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.saveSelectedSource(at: indexPath)
    }
}

extension SourceSelectionViewController: UISearchBarDelegate {
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
struct SourceSelectionControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = SourceSelectionModuleBuilder()
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
