//
//  CountryAnnotationView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 21/05/2023.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SnapKit

final class CountryAnnotationView: MKAnnotationView {
    private(set) var viewModel: CountryAnnotationViewModel?
    
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
        let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
        gradient.type = .axial
        gradient.cornerRadius = 35
        gradient.colors = [
            blue,
            darkBlue,
            darkBlue,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.25, 0.5, 1]
        return gradient
    }()
    
    private lazy var annotationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "countryCluster"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultHigh
        frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        self.layer.cornerRadius = 35
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(annotationView)
        annotationView.addSubview(flagImageView)
        annotationView.addSubview(countryNameLabel)
    }
    
    private func setConstraints() {
        annotationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(annotationView).inset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(35)
            make.centerX.equalTo(annotationView)
            make.top.equalTo(countryNameLabel.snp.bottom).offset(5)
        }
    }
    
    private func setViewBackground() {
        backgroundGradient.frame = self.bounds
        self.layer.addSublayer(backgroundGradient)
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: CountryAnnotationViewModel) {
        self.viewModel = viewModel
        countryNameLabel.setShadowLabel(string: viewModel.countryName, font: UIFont.systemFont(ofSize: 12, weight: .medium), shadowColor: .blue, radius: 3)
        flagImageView.image = UIImage(named: viewModel.countryCode)
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CountryAnnotationViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let annotationView = CountryAnnotationView()
            annotationView.configure(with: CountryAnnotationViewModel(countryName: "Émirats Arabes Unis", countryCode: "ae", coordinates: CLLocationCoordinate2D(latitude: 48.861066, longitude: 2.340169)))
            return annotationView
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CountryAnnotationView (dark)")
    }
}
#endif
