//
//  ArticleDetailViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 10/05/2023.
//

import UIKit
import SnapKit

extension UIButton {
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = 10
        self.layer.insertSublayer(gradient, at: 0)
    }
}

final class ArticleDetailViewController: UIViewController {
    var articleViewModel: ArticleViewModel?
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
        let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
        gradient.type = .axial
        gradient.colors = [blue, darkBlue, darkBlue, UIColor.black.cgColor]
        gradient.locations = [0, 0.25, 0.5, 1]
        return gradient
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        return view
    }()
    
    private lazy var scrollStackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        // stackView.backgroundColor = .orange
        return stackView
    }()
    
    private lazy var articleTopView: UIView = {
        let view = UIView()
        // view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var articleContentView: UIView = {
        let view = UIView()
        // view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var articleBottomView: UIView = {
        let view = UIView()
        // view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var articleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let publishDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        // stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // stackView.backgroundColor = .orange
        return stackView
    }()
    
    private lazy var clockContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private lazy var articlePublishDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        // label.backgroundColor = .systemGreen
        return label
    }()
    
    private lazy var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        // label.backgroundColor = .darkGray
        return label
    }()
    
    private let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        // stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // stackView.backgroundColor = .orange
        return stackView
    }()
    
    private lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private lazy var articleAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var articleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        // label.backgroundColor = .red
        return label
    }()
    
    private lazy var articleContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        // label.backgroundColor = .brown
        return label
    }()
    
    private let sourceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        // stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // stackView.backgroundColor = .orange
        return stackView
    }()
    
    private lazy var articleSourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var sourceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "newspaper.fill")
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private lazy var articleWebsiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Site web de l'article", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
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
        setButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        clockContainerView.layer.cornerRadius = 10
        clockContainerView.layer.shadowColor = UIColor.black.cgColor
        clockContainerView.layer.shadowOffset = .zero
        clockContainerView.layer.shadowRadius = 2
        clockContainerView.layer.shadowOpacity = 0.25
        clockContainerView.layer.shadowPath = UIBezierPath(roundedRect: clockImageView.bounds, cornerRadius: 10).cgPath
        
        articleWebsiteButton.applyGradient(colours: [UIColor(named: "SuperNewsBlue") ?? .blue, UIColor(named: "SuperNewsDarkBlue") ?? .black, .black], locations: [0, 0.75, 1])
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        // The view on top with the image of the article
        scrollStackViewContainer.addArrangedSubview(articleTopView)
        articleTopView.addSubview(articleImageView)
        articleImageView.addSubview(publishDateStackView)
        publishDateStackView.addArrangedSubview(clockContainerView)
        clockContainerView.addSubview(clockImageView)
        publishDateStackView.addArrangedSubview(articlePublishDateLabel)
        
        // The middle view with content
        scrollStackViewContainer.addArrangedSubview(articleContentView)
        articleContentView.addSubview(articleTitleLabel)
        
        // Author label with his logo
        articleContentView.addSubview(authorStackView)
        articleContentView.addSubview(authorStackView)
        authorStackView.addArrangedSubview(authorImageView)
        authorStackView.addArrangedSubview(articleAuthorLabel)
        
        // Description and content
        articleContentView.addSubview(articleDescriptionLabel)
        articleContentView.addSubview(articleContentLabel)
        
        // Source
        articleAuthorLabel.addSubview(sourceStackView)
        sourceStackView.addArrangedSubview(sourceImageView)
        sourceStackView.addArrangedSubview(articleSourceLabel)
        
        // Bottom view with button
        scrollStackViewContainer.addArrangedSubview(articleBottomView)
        articleBottomView.addSubview(articleWebsiteButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollStackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // MARK: - Top view with image
        articleTopView.snp.makeConstraints { make in
            // make.right.equalTo(scrollStackViewContainer).inset(15)
            // make.edges.equalTo(scrollStackViewContainer).inset(10)
            make.top.equalTo(scrollStackViewContainer.snp.top)
            make.height.equalTo(250)
        }
        
        articleImageView.snp.makeConstraints { make in
            make.edges.equalTo(articleTopView)
        }
        
        publishDateStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(articleImageView).inset(10)
            make.bottom.equalTo(articleImageView.snp.bottom).inset(10)
        }
        
        clockContainerView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.edges.equalTo(clockContainerView)
        }
        
        // MARK: - Under the top view, the content
        articleContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollStackViewContainer)
        }
        
        articleTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(articleContentView).inset(10)
            make.horizontalEdges.equalTo(articleContentView).inset(10)
        }
        
        authorStackView.snp.makeConstraints { make in
            make.top.equalTo(articleTitleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(articleContentView).inset(10)
        }
        
        authorImageView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        articleDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorStackView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(articleContentView).inset(10)
        }
        
        articleContentLabel.snp.makeConstraints { make in
            make.top.equalTo(articleDescriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(articleContentView).inset(10)
        }
        
        sourceStackView.snp.makeConstraints { make in
            make.top.equalTo(articleContentLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(articleContentView).inset(10)
            make.bottom.equalTo(articleContentView.snp.bottom).inset(30)
        }
        
        // MARK: - Under the middle view
        articleBottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollStackViewContainer)
        }
        
        articleWebsiteButton.snp.makeConstraints { make in
            make.top.equalTo(articleBottomView.snp.top)
            make.bottom.equalTo(articleBottomView.snp.bottom).inset(40)
            make.centerX.equalTo(articleBottomView)
            make.width.equalTo(articleBottomView).multipliedBy(0.7)
            make.height.equalTo(50)
        }
    }
    
    // Dependency injection
    func configure(with articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
        articleImageView.loadImage(with: articleViewModel.imageUrl)
        articlePublishDateLabel.setShadowLabel(string: articleViewModel.publishedAt, font: UIFont.systemFont(ofSize: 20, weight: .semibold), textColor: .white, shadowColor: .blue, radius: 3)
        articleTitleLabel.setShadowLabel(string: articleViewModel.title, font: UIFont.systemFont(ofSize: 22, weight: .semibold), textColor: .white, shadowColor: .black, radius: 3)
        articleAuthorLabel.text = articleViewModel.author
        articleDescriptionLabel.text = articleViewModel.description
        articleContentLabel.text = articleViewModel.content
        articleSourceLabel.text = articleViewModel.sourceName
    }
}

extension ArticleDetailViewController {
    private func setNavigationBar() {
        let item = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.forward.fill"), style: .plain, target: self, action: #selector(onClickShareButton))
        navigationItem.rightBarButtonItem = item
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setViewBackground() {
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    // This variant is available for UIKit in iOS 14 and later, no need anymore to use legacy addTarget with #selector.
    private func setButtonActions() {
        let websiteOpenAction = UIAction { _ in
            print("Site web à ouvrir")
        }
        
        articleWebsiteButton.addAction(websiteOpenAction, for: .touchUpInside)
    }
    
    @objc func onClickShareButton() {
        print("Partage du site à ouvrir")
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ArticleDetailSelectionControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = ArticleDetailModuleBuilder(articleViewModel: ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle()))
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