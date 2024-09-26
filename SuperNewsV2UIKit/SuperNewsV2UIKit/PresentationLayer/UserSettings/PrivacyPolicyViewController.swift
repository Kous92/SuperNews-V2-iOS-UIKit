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

    // J'ai vu dans tes extensions que tu faisais des fonctions pour cela, pourquoi pas ici ?
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

    // Pourquoi ne pas attacher le reusableIdentifier à ta cellule et ainsi ne jamais avoir à réfléchir ou à manquer de te tromper dans l'écriture d'une chaine en dur ?
    // static let reuseIdentifier = "" et l'utiliser comme cela PrivacyTableViewCell.reuseIdentifier

    // Et encore plus smart :
    //    protocol ReusableComponentIdentifiable {
    //        var reuseIdentifier: String { get }
    //    }
    //    extension ReusableComponentIdentifiable {
    //        static var reuseIdentifier: String { String(describing: Self.self) }
    //    }
    //
    //    final class MyTableViewCell: UITableViewCell, ReusableComponentIdentifiable {
    //
    //    }
    //
    //    tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)

    // D'une manière générale, et je te l'écris aussi une seule fois, mais valable pour toute l'app:
    // il y a beaucoup trop de chaine en "dur". C'est risque d'erreur, c'est une perte de temps, et ces deux points sont deja beaucoup trop
    // Pour les imageNames : des enum avec des static let à l'intérieur pour les constantes
    // tu peux ensuite faire un pattern de ce type
    // enum Constants { ... }
    // extension Constants { enum ImageName { ... } }
    // ect ...
    // Et comme ça, plus jamais tu cherches une info ou une valeur de string, c'est tout mis à un seul endroit

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

        // ce code la n'est associé qu'à la cell, alors autant le mettre dedans
        // quittes à le généraliser dans une extension de cell
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
