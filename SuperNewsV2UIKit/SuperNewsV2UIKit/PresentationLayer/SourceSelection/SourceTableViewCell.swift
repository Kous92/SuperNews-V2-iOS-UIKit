//
//  SourceTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 29/04/2023.
//

import UIKit
import SnapKit
import SafariServices

final class SourceTableViewCell: UITableViewCell {
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor(named: "SuperNewsDarkBlue")?.cgColor
        view.layer.borderWidth = 1
        // view.backgroundColor = UIColor(named: "SuperNewsBlue")
        return view
    }()
    
    private lazy var sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Nom du média source"
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Description complète du média source, nom, sa catégorie, le lieu, la langue, ..."
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.text = "Catégorie (business,...)"
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceCountryAndLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.text = "Pays et langue du média"
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceURLLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.text = "URL du média"
        label.textColor = .white
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
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
        cellView.addSubview(labelStackView)
        cellView.addSubview(sourceTitleLabel)
        cellView.addSubview(sourceDescriptionLabel)
        cellView.addSubview(sourceCategoryLabel)
        cellView.addSubview(sourceCountryAndLanguageLabel)
        cellView.addSubview(sourceURLLabel)
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        sourceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cellView.snp.top).inset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        sourceTitleLabel.setContentHuggingPriority(.defaultHigh + 4, for: .vertical)
        
        sourceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(10)
        }
        
        sourceDescriptionLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        
        sourceCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceDescriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(10)
        }
        
        sourceCategoryLabel.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        
        sourceCountryAndLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCategoryLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(10)
        }
        
        sourceCountryAndLanguageLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        sourceURLLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCountryAndLanguageLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(10)
            make.bottom.equalTo(cellView.snp.bottom).inset(10)
        }
        
        sourceURLLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: SourceCellViewModel) {
        sourceTitleLabel.text = viewModel.name
        sourceDescriptionLabel.text = viewModel.description
        sourceCategoryLabel.text = "Catégorie: \(viewModel.category.getCategoryNameFromCategoryCode())"
        sourceCountryAndLanguageLabel.text = "Pays: \(viewModel.country.countryName()?.capitalized ?? "??"), langue: \(viewModel.language.languageName()?.capitalized ?? "??")"
        sourceURLLabel.text = "URL du site du média: \(viewModel.url)"
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SourceTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = SourceTableViewCell()
            view.configure(with: SourceCellViewModel(with: SourceDTO.getFakeObjectFromSource()))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CustomTableViewCell (dark)")
    }
}
#endif
