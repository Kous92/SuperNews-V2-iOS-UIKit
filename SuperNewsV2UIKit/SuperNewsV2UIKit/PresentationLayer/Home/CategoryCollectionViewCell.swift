//
//  CategoryCollectionViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 26/04/2023.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    private lazy var categoryTitleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.textColor = .white
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
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(with title: String) {
        categoryTitleLabel.text = title
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    override var isSelected: Bool {
        didSet {
            categoryTitleLabel.textColor = isSelected ? .orange : .white
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
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CategoryCollectionViewCell (dark)")
    }
}
#endif
