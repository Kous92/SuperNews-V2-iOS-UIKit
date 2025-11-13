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
        let gradient = getGradient2()
        gradient.cornerRadius = 15
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
    
    // MARK: - SwiftUI hosting (no @available here)
    private var hostingController: AnyObject?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .rectangle
        
        frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        centerOffset = CGPoint(x: 0, y: 0)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        if #unavailable(iOS 26.0) {
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerCurve = .continuous
        }
        
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Display
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let cluster = annotation as? MKClusterAnnotation else {
            return
        }
        
        let count = cluster.memberAnnotations.count
        
        if #available(iOS 26.0, *) {
            // SwiftUI Glass Version
            let glassView = CountryClusterAnnotationGlassView(count: count)
            let hc = UIHostingController(rootView: glassView)
            hc.view.backgroundColor = .clear
            hc.view.translatesAutoresizingMaskIntoConstraints = false
            
            // Remove UIKit subviews if any
            countryCountLabel.removeFromSuperview()
            backgroundGradient.removeFromSuperlayer()
            
            // Remove old hosting controller
            (hostingController as? UIViewController)?.view.removeFromSuperview()
            
            addSubview(hc.view)
            hc.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.height.equalTo(100)
            }
            
            hostingController = hc
            
        } else {
            // UIKit fallback version
            (hostingController as? UIViewController)?.view.removeFromSuperview()
            hostingController = nil
            
            // Rebuild UIKit layout if removed
            if countryCountLabel.superview == nil {
                setViewBackground()
                buildViewHierarchy()
                setConstraints()
            }
            
            if count > 0 {
                displayPriority = .defaultLow
                countryCountLabel.setShadowLabel(
                    string: String(count),
                    font: UIFont.systemFont(ofSize: 17, weight: .medium),
                    shadowColor: .blue,
                    radius: 3
                )
            } else {
                displayPriority = .defaultHigh
            }
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

#Preview("CountryClusterAnnotationView") {
    let annotationView = CountryClusterAnnotationView()
    return annotationView
}
#endif
