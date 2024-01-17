//
//  CategoryCollectionViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 26/04/2023.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    // Donc en fait, tu utilises bien un fichier de constant, mais pas de partout ?
    // Dommage.
    private lazy var categoryTitleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: Constants.CategoryCollectionView.categoryTitleFontSize, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildViewHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(categoryTitleLabel)
    }
    
    private func setConstraints() {
        categoryTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.CategoryCollectionView.categoryTitleInsets)
        }
    }
    
    func configure(with title: String) {
        categoryTitleLabel.text = title
        categoryTitleLabel.textColor = isSelected ? .white : .lightGray
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIDevice.current.userInterfaceIdiom == .phone ? 40 : 70)
    }
    
    override var isSelected: Bool {
        didSet {
            categoryTitleLabel.textColor = isSelected ? .white : .lightGray
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CategoryCollectionViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = CategoryCollectionViewCell()
            view.configure(with: "News category")
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CategoryCollectionViewCell (dark)")
    }
}
#endif
