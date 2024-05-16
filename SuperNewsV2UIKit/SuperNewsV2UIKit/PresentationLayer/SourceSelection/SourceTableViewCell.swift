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
        view.layer.cornerRadius = Constants.SourceSelectionCell.viewCornerRadius
        view.layer.borderColor = UIColor(resource: .superNewsLightGray).cgColor
        view.layer.borderWidth = 0.4
        // view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.backgroundColor = UIColor(resource: .superNewsDarkBlue)
        return view
    }()
    
    private lazy var sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.SourceSelectionCell.titleLabelFontSize, weight: .semibold)
        label.text = String(localized: "mediaSourceName")
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.SourceSelectionCell.descriptionLabelFontSize, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.SourceSelectionCell.otherLabelFontSize, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceCountryAndLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.SourceSelectionCell.otherLabelFontSize, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var sourceURLLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.SourceSelectionCell.otherLabelFontSize, weight: .medium)
        label.text = String(localized: "mediaURL")
        label.textColor = .white
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.SourceSelectionCell.labelStackViewSpacing
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
            make.edges.equalToSuperview().inset(Constants.SourceSelectionCell.viewInsets)
        }
        
        sourceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cellView.snp.top).inset(Constants.SourceSelectionCell.margin10)
            make.horizontalEdges.equalToSuperview().inset(Constants.SourceSelectionCell.horizontalMargin)
        }
        
        sourceTitleLabel.setContentHuggingPriority(.defaultHigh + 4, for: .vertical)
        
        sourceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceTitleLabel.snp.bottom).offset(Constants.SourceSelectionCell.margin10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(Constants.SourceSelectionCell.horizontalMargin)
        }
        
        sourceDescriptionLabel.setContentHuggingPriority(.defaultHigh + 3, for: .vertical)
        
        sourceCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceDescriptionLabel.snp.bottom).offset(Constants.SourceSelectionCell.margin10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(Constants.SourceSelectionCell.horizontalMargin)
        }
        
        sourceCategoryLabel.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        
        sourceCountryAndLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCategoryLabel.snp.bottom).offset(Constants.SourceSelectionCell.margin10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(Constants.SourceSelectionCell.horizontalMargin)
        }
        
        sourceCountryAndLanguageLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        sourceURLLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCountryAndLanguageLabel.snp.bottom).offset(Constants.SourceSelectionCell.margin10)
            make.horizontalEdges.equalTo(cellView.snp.horizontalEdges).inset(Constants.SourceSelectionCell.horizontalMargin)
            make.bottom.equalTo(cellView.snp.bottom).inset(Constants.SourceSelectionCell.margin10)
        }
        
        sourceURLLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: SourceCellViewModel) {
        sourceTitleLabel.text = viewModel.name
        sourceDescriptionLabel.text = viewModel.description
        sourceCategoryLabel.text = "\(String(localized: "category")): \(viewModel.category.getCategoryNameFromCategoryCode())"
        sourceCountryAndLanguageLabel.text = "\(String(localized: "country")): \(viewModel.country.countryName()?.capitalized ?? "??"), \(String(localized: "language")): \(viewModel.language.languageName()?.capitalized ?? "??")"
        sourceURLLabel.text = "\(String(localized: "mediaURL")): \(viewModel.url)"
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
