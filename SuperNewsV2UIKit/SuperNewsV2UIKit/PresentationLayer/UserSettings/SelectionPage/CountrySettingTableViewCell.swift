//
//  CountrySettingTableViewCell.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/07/2023.
//

import UIKit
import SnapKit

final class CountrySettingTableViewCell: UITableViewCell {

    private lazy var countryFlagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "fr")
        imageView.tintColor = .orange
        
        return imageView
    }()
    
    // Un peu à la manière d'un design system, tu pourrais mettre en "constant" les fonts, et ainsi ne jamais douter de ce que tu utilises, où tu comptes l'utiliser
    // genre title, subtitle, body ... ect 
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
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
        contentView.addSubview(countryFlagImage)
        contentView.addSubview(countryNameLabel)
    }
    
    // ce qui est valable pour les constant String est également valable pour les constants Int
    // De plus, ton padding devrait être le meme de partout, donc forcément, tu ne te tromperas jamais si tu le généralises qq part
    private func setConstraints() {
        countryFlagImage.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(55)
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(countryFlagImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(countryFlagImage.snp.centerY)
        }
    }
    
    func configure(with viewModel: CountrySettingViewModel) {
        countryFlagImage.image = UIImage(named: viewModel.flagCode)
        countryNameLabel.text = viewModel.name
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CountrySettingTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = CountrySettingTableViewCell()
            view.configure(with: CountrySettingViewModel.init(code: "fr", name: "France", flagCode: "fr", isSaved: false))
            return view
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CountrySettingTableViewCell (dark)")
    }
}
#endif
