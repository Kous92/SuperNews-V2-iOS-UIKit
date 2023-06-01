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
        // image.image = UIImage(named: "fr")
        return image
    }()
    
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        // label.text = "France"
        UIFont.systemFont(ofSize: 16, weight: .medium)
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
        addSubview(flagImageView)
        addSubview(countryNameLabel)
    }
    
    private func setConstraints() {
        flagImageView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(35)
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(flagImageView.snp.centerY)
        }
    }
    // Dependency injection
    func configure(with viewModel: CountryAnnotationViewModel) {
        flagImageView.image = UIImage(named: viewModel.countryCode)
        countryNameLabel.text = viewModel.countryName
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
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
