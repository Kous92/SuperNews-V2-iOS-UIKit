//
//  NewsTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import UIKit
import SnapKit

final class NewsTableViewCell: UITableViewCell {
    
    private var title: String = ""
    private var source: String = ""
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var articleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
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
        addSubview(cellView)
        cellView.addSubview(articleImageView)
        articleImageView.addSubview(titleLabel)
        articleImageView.addSubview(sourceLabel)
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        articleImageView.snp.makeConstraints { make in
            make.edges.equalTo(cellView).inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(articleImageView.snp.bottomMargin).inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.top).inset(10)
            make.horizontalEdges.equalTo(articleImageView).inset(10)
        }
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: NewsCellViewModel) {
        articleImageView.loadImage(with: viewModel.imageURL)
        sourceLabel.setShadowLabel(string: viewModel.source, font: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: .white, shadowColor: .blue, radius: 3)
        titleLabel.setShadowLabel(string: viewModel.title, font: UIFont.systemFont(ofSize: 17, weight: .semibold), textColor: .white, shadowColor: .blue, radius: 3)
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
