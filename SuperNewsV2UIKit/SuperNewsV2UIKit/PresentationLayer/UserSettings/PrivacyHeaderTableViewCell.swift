//
//  PrivacyHeaderTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/12/2023.
//

import Foundation
import UIKit

final class PrivacyHeaderTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.PrivacyPolicy.titleLabelFontSize, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.PrivacyPolicy.dateLabelFontSize, weight: .medium)
        label.text = ""
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.PrivacyPolicy.topMargin)
            make.horizontalEdges.equalToSuperview().inset(Constants.PrivacyPolicy.horizontalMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.PrivacyPolicy.dateTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constants.PrivacyPolicy.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constants.PrivacyPolicy.dateBottomMargin)
        }
    }
    
    func configure(with viewModel: PrivacyHeaderViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = "\(String(localized: "updateDate")): \(viewModel.date)"
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PrivacyHeaderTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = PrivacyHeaderTableViewCell()
            view.configure(with: PrivacyHeaderViewModel(title: "SuperNews privacy policy", date: "2023-12-21"))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("PrivacyTableViewCell (dark)")
    }
}
#endif
