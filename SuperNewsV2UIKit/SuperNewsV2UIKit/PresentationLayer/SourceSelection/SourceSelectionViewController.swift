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
    
    // weak var coordinator: HomeViewControllerDelegate?
    
    // MVVM with Reactive Programming
    private let categoryViewModels = CategoryCellViewModel.getSourceCategories()
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
        
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: "sourceCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        // tableView.isHidden = true
        tableView.backgroundColor = .clear
        
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
        // viewModel?.fetchAllSources()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(loadingSpinner)
        view.addSubview(categoryCollectionView)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
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
    }
}

extension SourceSelectionViewController {
    private func setNavigationBar() {
        navigationItem.title = "Choix de la source"
        navigationController?.navigationBar.tintColor = .white
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
        /*
        noResultLabel.isHidden = false
        noResultLabel.text = "Aucun article disponible"
         */
    }
    
    private func updateTableView() {
        print("Update TableView")
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

extension SourceSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: categoryViewModels[indexPath.item].title)
        
        // When view is initialized, the first cell is selected by default
        if indexPath.item == 0 {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            viewModel?.setSourceOption(with: categoryViewModels[indexPath.item].categoryId)
        }
        
        return cell
    }
}

extension SourceSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.setSourceOption(with: categoryViewModels[indexPath.item].categoryId)
    }
}

extension SourceSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = viewModel?.sectionViewModels.count, sections > 0 else {
            return 1
        }
        
        print("Sections à afficher: \(sections)")
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print(section)
        // print(viewModel?.sectionViewModels.count ?? 0)
        
        guard let viewModels = viewModel?.sectionViewModels, viewModels.count > 0 else {
            return 0
        }
        
        return viewModel?.sectionViewModels[section].sourceCellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as? SourceTableViewCell else {
            return UITableViewCell()
        }
        
        if let cellViewModel = viewModel?.sectionViewModels[indexPath.section].sourceCellViewModels[indexPath.row] {
            cell.configure(with: cellViewModel)
        }
        
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = viewModel?.sections, sections > 0 else {
            return nil
        }
        
        guard let viewModels = viewModel?.sectionViewModels, viewModels.count > 0 else {
            return nil
        }
        
        return viewModel?.sectionViewModels[section].sectionName
    }
}

extension SourceSelectionViewController: UITableViewDelegate {
    
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
                let useCase = SourceSelectionUseCase(repository: SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false)))
                let viewModel = SourceSelectionViewModel(useCase: useCase)
                let vc = SourceSelectionViewController()
                vc.viewModel = viewModel
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
