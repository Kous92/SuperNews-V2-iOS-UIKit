//
//  PrivacyTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/12/2023.
//

import UIKit
import SnapKit

final class PrivacyTableViewCell: UITableViewCell {
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.PrivacyPolicy.subtitleLabelFontSize, weight: .semibold)
        label.text = String(localized: "mediaSourceName")
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.PrivacyPolicy.descriptionFontSize, weight: .regular)
        label.text = String(localized: "mediaSourceName")
        label.setLineSpacing(lineSpacing: Constants.PrivacyPolicy.lineSpacing)
        label.textColor = .white
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
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setConstraints() {
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.PrivacyPolicy.topMargin)
            make.horizontalEdges.equalToSuperview().inset(Constants.PrivacyPolicy.horizontalMargin)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.PrivacyPolicy.subtitleOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.PrivacyPolicy.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constants.PrivacyPolicy.bottomMargin)
        }
    }
    
    func configure(with viewModel: PrivacyCellViewModel) {
        subtitleLabel.text = viewModel.subtitle
        descriptionLabel.text = viewModel.description
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PrivacyTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = PrivacyTableViewCell()
            let dto = PrivacyPolicyDTO.getFakeObjectFromPrivacyPolicy()
            let cellViewModels = dto.sections.map { section in
                PrivacyCellViewModel(subtitle: section.subtitle, description: section.content)
            }
            view.configure(with: cellViewModels[0])
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("PrivacyTableViewCell (dark)")
    }
}
#endif
