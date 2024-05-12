//
//  NewsTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import UIKit
import SnapKit

final class NewsTableViewCell: UITableViewCell {
    private lazy var cellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cellBlurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    private lazy var articleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = Constants.NewsCell.imageCornerRadius
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(cellView)
        cellView.addSubview(articleImageView)
        articleImageView.addSubview(cellBlurView)
        cellBlurView.addSubview(titleLabel)
        cellBlurView.addSubview(sourceLabel)
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        articleImageView.snp.makeConstraints { make in
            make.edges.equalTo(cellView).inset(Constants.NewsCell.imageInsets)
        }
        
        cellBlurView.snp.makeConstraints { make in
            make.edges.equalTo(articleImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(articleImageView.snp.bottomMargin).inset(Constants.NewsCell.bottomMargin)
            make.horizontalEdges.equalToSuperview().inset(Constants.NewsCell.horizontalMargin)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.top).inset(Constants.NewsCell.horizontalMargin)
            make.horizontalEdges.equalTo(articleImageView).inset(Constants.ArticleDetail.horizontalMargin)
        }
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: NewsCellViewModel) {
        articleImageView.loadImage(with: viewModel.imageURL)
        sourceLabel.setShadowLabel(string: viewModel.source, font: UIFont.systemFont(ofSize: Constants.NewsCell.sourceLabelFontSize, weight: .medium), textColor: .white, shadowColor: .black, radius: 3)
        titleLabel.setShadowLabel(string: viewModel.title, font: UIFont.systemFont(ofSize: Constants.NewsCell.titleLabelFontSize, weight: .semibold), textColor: .white, shadowColor: .black, radius: 3)
        
        // In case of loading issue, force with default placeholder
        if articleImageView.image == nil {
            articleImageView.image = articleImageView.defaultPlaceholderImage()
        }
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (9 / 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumbnail Image View
        articleImageView.cancelDownloadTask()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CustomTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = NewsTableViewCell()
            let article = ArticleDTO.getFakeObjectFromArticle()
            view.configure(with: NewsCellViewModel(imageURL: article.imageUrl, title: article.title, source: article.sourceName))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CustomTableViewCell (dark)")
    }
}
#endif
