//
//  CountryClusterAnnotationView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 22/05/2023.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SnapKit

final class CountryClusterAnnotationView: MKAnnotationView {
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
        let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
        gradient.type = .axial
        gradient.cornerRadius = 15
        gradient.colors = [
            blue,
            darkBlue,
            darkBlue,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.25, 0.5, 1]
        return gradient
    }()
    
    private lazy var countryCountLabel: UILabel = {
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
        collisionMode = .rectangle
        
        frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        centerOffset = CGPoint(x: 0, y: 0)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerCurve = .continuous
        
        
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
        countryCountLabel.setShadowLabel(string: "0", font: UIFont.systemFont(ofSize: 17, weight: .medium), shadowColor: .blue, radius: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let cluster = annotation as? MKClusterAnnotation else {
            return
        }
        
        let countries = cluster.memberAnnotations.count
        
        if countries > 0 {
            displayPriority = .defaultLow
            countryCountLabel.setShadowLabel(string: String(countries), font: UIFont.systemFont(ofSize: 17, weight: .medium), shadowColor: .blue, radius: 3)
        } else {
            displayPriority = .defaultHigh
        }
    }
    
    func buildViewHierarchy() {
        addSubview(countryCountLabel)
    }
    
    func setConstraints() {
        countryCountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setViewBackground() {
        backgroundGradient.frame = self.bounds
        self.layer.addSublayer(backgroundGradient)
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CountryClusterAnnotationViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let annotationView = CountryClusterAnnotationView()
            return annotationView
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .preferredColorScheme(.dark)
        .previewDisplayName("CountryClusterAnnotationView (dark)")
    }
}
#endif
