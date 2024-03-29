//
//  TopHeadlinesViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import UIKit
import SnapKit
import Combine

final class TopHeadlinesViewController: UIViewController {
    // MVVM with Reactive Programming
    var viewModel: TopHeadlinesViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var gradient: CAGradientLayer = {
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
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "categoryCollectionView"
        
        return collectionView
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
        tableView.accessibilityIdentifier = "tableView"
        
        return tableView
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
        
        setTabBar()
        setNavigationBar()
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
        setBindings()
        viewModel?.initCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // To avoid any issue especially if we switched from dark to light mode
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        viewModel?.loadAndUpdateSourceCategoryTitle()
        viewModel?.loadAndUpdateUserCountrySettingTitle()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(loadingSpinner)
        view.addSubview(noResultLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.TopHeadlines.horizontalMargin)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constants.CategoryCollectionView.collectionViewHeight)
        }
    }
    
    private func setBindings() {
        // Loading binding
        viewModel?.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.setLoadingSpinner(isLoading: true)
                    self?.hideTableView()
                }
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
        
        viewModel?.categoryUpdateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] reload, indexUpdate in
                if reload {
                    self?.updateCollectionView(reloadData: reload, updateIndex: indexUpdate)
                }
            }.store(in: &subscriptions)
    }
    
    @objc func onClickSourceButton() {
        viewModel?.goToSourceSelectionView()
    }
}

extension TopHeadlinesViewController {
    private func setTabBar() {
        self.tabBarController?.delegate = self
    }
    
    private func setNavigationBar() {
        navigationItem.title = tabBarController?.tabBar.items?[0].title
        let item = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(onClickSourceButton))
        navigationItem.rightBarButtonItem = item
        navigationController?.navigationBar.tintColor = .white
        
        // For UI testing
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "listButton"
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    private func hideTableView() {
        tableView.isHidden = true
    }
    
    private func displayNoResult() {
        tableView.isHidden = true
        noResultLabel.isHidden = false
    }
    
    private func updateTableView() {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.isHidden = false
    }
    
    private func updateCollectionView(reloadData: Bool, updateIndex: Int) {
        // When view is initialized, the first cell is selected by default. But apply it only once, the first time. Not after every reload data.
        print("UPDATE CELL: \(reloadData), AND SELECTION AT \(updateIndex)")
        
        if reloadData {
            print("UPDATE CELL AND SELECTION AT \(updateIndex)")
            categoryCollectionView.reloadData()
        }
        
        // This index indicates the item to select. 0 for favorite country, 1 for favorite source
        if updateIndex == 0 || updateIndex == 1 {
            categoryCollectionView.selectItem(at: IndexPath(item: updateIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        
        categoryCollectionView.isHidden = false
    }
    
    private func setLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
    }
}

extension TopHeadlinesViewController: UITableViewDataSource {
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

extension TopHeadlinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.goToArticleDetailView(selectedViewModelIndex: indexPath.row)
    }
}

extension TopHeadlinesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInCollectionView() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell,
              let categoryViewModel = viewModel?.getCategoryCellViewModel(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: categoryViewModel.title)
        
        return cell
    }
}

extension TopHeadlinesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categoryViewModel = viewModel?.getCategoryCellViewModel(at: indexPath) else {
            return
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if categoryViewModel.categoryId == "local" {
            viewModel?.fetchTopHeadlines()
        }
        else if categoryViewModel.categoryId == "source" {
            viewModel?.fetchTopHeadlinesWithSource()
        }
        else {
            viewModel?.fetchTopHeadlines(with: categoryViewModel.categoryId)
        }
    }
}

extension TopHeadlinesViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // When tapping on the current TabBar, it scrolls back to top, but only if rows are visible.
        let numberOfRows = viewModel?.numberOfRowsInTableView() ?? 0
        
        if numberOfRows > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let tabBar = GradientTabBarController()
                let navigationController = UINavigationController()
                let builder = TopHeadlinesModuleBuilder()
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
