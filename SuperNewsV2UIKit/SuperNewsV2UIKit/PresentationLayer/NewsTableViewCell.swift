//
//  NewsTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    private lazy var cellView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 3
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = CGColor(red: 0, green: 0, blue: 255, alpha: 1)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 3
        label.layer.shadowOffset = .zero
        label.layer.shadowColor = CGColor(red: 0, green: 0, blue: 255, alpha: 1)
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
    
    func configure(with viewModel: NewsCellViewModel) {
        titleLabel.text = viewModel.title
        sourceLabel.text = viewModel.source
        articleImageView.loadImage(with: viewModel.imageURL)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (9 / 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumbnail Image View
        articleImageView.cancelDownloadTask()
    }
    
    // No background on cell selection
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = .clear
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
