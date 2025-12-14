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
import SwiftUI

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
        // self.layer.cornerRadius = 15
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
    
    /*
     override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
     super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
     collisionMode = .rectangle
     
     // ANCIEN : frame = CGRect(x: 0, y: 0, width: 60, height: 60)
     // NOUVEAU : On définit une frame initiale minimale, elle sera ajustée dans prepareForDisplay
     frame = CGRect(x: 0, y: 0, width: 60, height: 60)
     
     centerOffset = CGPoint(x: 0, y: 0)
     // On retire la taille fixe ici, elle sera mise à jour dans prepareForDisplay
     // self.layer.cornerRadius = 15 // Le corner radius sera ajusté
     self.clipsToBounds = true
     
     if #unavailable(iOS 26.0) {
     // ... (autres paramètres UIKit fallback)
     }
     
     setViewBackground()
     buildViewHierarchy()
     setConstraints()
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateSizeForContent(count: Int) -> CGSize {
        // Utiliser la police qui sera affichée.
        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
        let text = String(count)
        
        // Calculer la taille minimale nécessaire pour le texte.
        let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = text.boundingRect(
            with: targetSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        // Ajouter un padding de 10 points (par exemple) autour du texte.
        let padding: CGFloat = 20
        let size = max(60, ceil(boundingRect.width) + padding, ceil(boundingRect.height) + padding)
        
        return CGSize(width: size, height: size)
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
                make.size.greaterThanOrEqualTo(100)
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
            
            let newSize = calculateSizeForContent(count: count) // Calcul de la nouvelle taille
            
            // Mise à jour de la frame, des coins et du background
            self.frame = CGRect(origin: self.frame.origin, size: newSize)
            self.layer.cornerRadius = newSize.width / 3.0 // Rayon de coin adapté à la nouvelle taille
            backgroundGradient.frame = self.bounds
            
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
    
    func testDisplay(with count: Int) {
        countryCountLabel.text = "\(count)"
    }
    
    private func setViewBackground() {
        backgroundGradient.frame = self.bounds
        self.layer.addSublayer(backgroundGradient)
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return calculateSizeForContent(count: 0)
    }
}

#if DEBUG
#Preview("CountryClusterAnnotationView") {
    let annotationView = CountryClusterAnnotationView()
    annotationView.testDisplay(with: 10)
    return annotationView
}
#endif
