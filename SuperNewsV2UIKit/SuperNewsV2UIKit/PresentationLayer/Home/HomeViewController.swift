//
//  HomeViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController {
    
    private var dataAPI: SuperNewsDataAPIService?
    weak var coordinator: HomeViewControllerDelegate?
    
    // MVVM with Reactive Programming
    // let service = SuperNewsMockDataAPIService(forceFetchFailure: false)
    // let repository = SuperNewsDataRepository(apiService: SuperNewsMockDataAPIService(forceFetchFailure: false))
    // let useCase = TopHeadlinesUseCase(repository: repository)
    var viewModel: HomeViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
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
        label.text = "Aucun article disponible"
        label.textAlignment = .center
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 3
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = CGColor(red: 0, green: 0, blue: 255, alpha: 1)
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
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "SuperNewsDarkBlue")
        buildViewHierarchy()
        tableView.backgroundColor = .clear
        setConstraints()
        setBindings()
        viewModel?.fetchTopHeadlines()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(loadingSpinner)
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("OK: terminé")
                    case .failure(let error):
                        print("Erreur reçue: \(error.rawValue)")
                }
            } receiveValue: { [weak self] updated in
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

extension HomeViewController {
    private func hideTableView() {
        tableView.isHidden = true
    }
    
    private func displayNoResult() {
        tableView.isHidden = true
        noResultLabel.isHidden = false
        noResultLabel.text = "Aucun article disponible."
    }
    
    private func updateTableView() {
        noResultLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func setLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingSpinner.startAnimating()
            // loadingSpinner.isHidden = false
        } else {
            loadingSpinner.stopAnimating()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.viewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        if let articleViewModel = viewModel?.viewModels[indexPath.row] {
            cell.configure(with: articleViewModel)
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        // Dark mode
        UIViewControllerPreview {
            let builder = HomeModuleBuilder()
            let vc = builder.buildModule(testMode: true)
            return vc
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        .preferredColorScheme(.dark)
        .previewDisplayName("iPhone 14 Pro")
        .edgesIgnoringSafeArea(.all)
    }
}
#endif
