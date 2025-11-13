//
//  CategoryCollectionViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 26/04/2023.
//

import UIKit
import SnapKit
import SwiftUI

final class CategoryCollectionViewCell: UICollectionViewCell {
    private var state = CellState()
    
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
    
    private lazy var liquidGlassView: UIVisualEffectView = {
        var view = UIVisualEffectView()
        
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect(style: .regular)
            glassEffect.isInteractive = true
            view = UIVisualEffectView(effect: glassEffect)
        } else {
            // Fallback on earlier versions
            let glassEffect = UIBlurEffect(style: .regular)
            view = UIVisualEffectView(effect: glassEffect)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    
    private func setEffect() {
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect(style: .clear)
            glassEffect.isInteractive = true
            liquidGlassView = UIVisualEffectView(effect: glassEffect)
        } else {
            // Fallback on earlier versions
            let glassEffect = UIBlurEffect(style: .regular)
            liquidGlassView = UIVisualEffectView(effect: glassEffect)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        // buildViewHierarchy()
        // setConstraints()
        // setEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentConfiguration = nil
    }
    
    private func buildViewHierarchy() {
        // Create a SwiftUI view
        if #available(iOS 26.0, *) {
            /*
            let swiftUIView = CategoryCellView(title: "Top Headlines")
            // Create a UIHostingController
            let hostingController = UIHostingController(rootView: swiftUIView)
            
            let hostView = hostingController.view
            hostingController.view.frame = contentView.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            if let hostView {
                contentView.addSubview(hostView)
            }
            */
        } else {
            // Fallback on earlier versions
            contentView.addSubview(liquidGlassView)
            contentView.addSubview(categoryTitleLabel)
        }
        
    }
    
    private func setConstraints() {
        liquidGlassView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.CategoryCollectionView.categoryTitleInsets)
        }
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.edges.equalTo(liquidGlassView).inset(12)
        }
    }
    
    func configure(with title: String) {
        categoryTitleLabel.text = title
        categoryTitleLabel.textColor = isSelected ? .white : .lightGray
        
        self.contentConfiguration = UIHostingConfiguration {
            let view = CategoryCellView(title: title, state: state)
            return view
        }
        .background(.clear)
        .margins(.all, 0)
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIDevice.current.userInterfaceIdiom == .phone ? 40 : 70)
    }
    
    override var isSelected: Bool {
        didSet {
            state.isSelected = isSelected
            categoryTitleLabel.textColor = isSelected ? .white : .lightGray
        }
    }
}

#if canImport(SwiftUI) && DEBUG
#Preview("CategoryCollectionViewCell") {
    let view = CategoryCollectionViewCell()
    view.configure(with: "News category")
    view.isSelected = true
    return view
}
#endif
