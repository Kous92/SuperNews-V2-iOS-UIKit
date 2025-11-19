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
        let gradient = getGradient2()
        
        return gradient
    }()
    
    private var collectionViewHeightConstraint: Constraint?
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = makeCategoriesHorizontalLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Ajustement dynamique de la hauteur
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // tentative de mise à jour (on vérifie que la hauteur est > 0)
        updateCollectionViewHeightIfNeeded()
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
            // make.height.equalTo(Constants.CategoryCollectionView.collectionViewHeight)
            // hauteur initiale raisonnable pour éviter frame = 0 et scroll vertical au démarrage
            collectionViewHeightConstraint = make.height.equalTo(Constants.CategoryCollectionView.collectionViewHeight).constraint
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
    
    private func updateCollectionViewHeightIfNeeded() {
        // Mesure actuelle fournie par le layout
        let measuredHeight = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height

        // Debug prints utiles
        // print("Measured content height = \(measuredHeight), frame.height = \(collectionView.frame.height)")

        guard measuredHeight > 0 else { return }

        // Si la hauteur mesurée est différente de la contrainte en place, on update
        let currentConstraintValue = collectionViewHeightConstraint?.layoutConstraints.first?.constant ?? -1
        if abs(currentConstraintValue - measuredHeight) > 0.1 {
            collectionViewHeightConstraint?.update(offset: measuredHeight)
            // Assure un layout immédiat si besoin
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    private func makeCategoriesHorizontalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .estimated(44)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .estimated(44)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

        // IMPORTANT: on s'assure que la section ne forçe pas un comportement vertical
        // section.supplementariesFollowContentInsets = false
        section.supplementaryContentInsetsReference = .none

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Dynamic Type support
    private func observeDynamicTypeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDynamicTypeChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func handleDynamicTypeChange() {
        // Invalide le layout puis force un recalcul propre
        categoryCollectionView.collectionViewLayout.invalidateLayout()

        // reload + performBatchUpdates pour s'assurer que la collection mesure correctement
        categoryCollectionView.reloadData()
        categoryCollectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.updateCollectionViewHeightIfNeeded()
        }
        
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

#if DEBUG
#Preview("TopHeadlinesViewController preview") {
    let tabBar = UITabBarController()
    let navigationController = UINavigationController()
    let builder = TopHeadlinesModuleBuilder()
    let vc = builder.buildModule(testMode: true)
    
    vc.tabBarItem = UITabBarItem(title: String(localized: "news"), image: UIImage(systemName: "newspaper"), tag: 0)
    navigationController.pushViewController(vc, animated: false)
    tabBar.viewControllers = [navigationController]
    
    return tabBar
}

#endif
