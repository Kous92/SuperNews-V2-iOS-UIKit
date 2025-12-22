//
//  CountryAutoCompletionTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/06/2023.
//

import UIKit
import SnapKit

final class CountryAutoCompletionTableViewCell: UITableViewCell {
    
    private lazy var flagImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: 15, weight: .medium)
        )
        
        // For Liquid Glass view
        if #available(iOS 26.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .white
        }

        return label
    }()
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.backgroundColor = .green
        
        return view
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
        // contentView.backgroundColor = .yellow
        contentView.addSubview(cellView)
        cellView.addSubview(flagImageView)
        cellView.addSubview(countryNameLabel)
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.horizontalEdges.equalToSuperview()
        }
        
        flagImageView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(40)
            make.leading.equalTo(cellView.snp.leading).inset(15)
            make.centerY.equalTo(cellView.snp.centerY)
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImageView.snp.trailing).offset(10)
            make.trailing.equalTo(cellView.snp.trailing ).inset(15)
            make.verticalEdges.equalTo(cellView.snp.verticalEdges).inset(10)
        }
    }
    // Dependency injection
    func configure(with viewModel: CountryAnnotationViewModel) {
        flagImageView.image = UIImage(named: viewModel.countryCode)
        countryNameLabel.text = viewModel.countryName
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CountryAutoCompletionTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view =  CountryAutoCompletionTableViewCell()
            view.configure(with: CountryAnnotationViewModel(with: CountryDTO.getFakeObjectFromCountry()))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CountryAutoCompletionTableViewCell (dark)")
    }
}
#endif
