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
    // Dynamic Type ratios
    private var viewSizeRatio: CGFloat {
        let category = traitCollection.preferredContentSizeCategory
        
        switch category {
        case .extraSmall, .small, .medium, .large, .extraLarge:
            return 1.0
        case .extraExtraLarge:
            return 1.2
        case .extraExtraExtraLarge:
            return 1.6
            // Correspondances approximatives avec les niveaux d'accessibilité SwiftUI
        case .accessibilityMedium, .accessibilityLarge: // Equivalent accessibility 1 & 2
            return 2.1
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge: // Equivalent 3, 4, 5
            return 2.6
        default:
            return 1.0
        }
    }
    
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = getGradient2()
        gradient.cornerRadius = 15
        return gradient
    }()
    
    private lazy var countryCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
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
        
        frame = CGRect(x: 0, y: 0, width: 60 * viewSizeRatio, height: 60 * viewSizeRatio)
        centerOffset = CGPoint(x: 0, y: 0)
        // self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        if #unavailable(iOS 26.0) {
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerCurve = .continuous
        }
        
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            
            // Si la catégorie de taille de contenu a changé
            if self.traitCollection.preferredContentSizeCategory != previousTraitCollection.preferredContentSizeCategory {
                print("Change size")
                // On force le redessin si on est en mode UIKit pur
                if #unavailable(iOS 26.0) {
                    self.updateLayoutForDynamicType()
                }
            }
        })
        
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Nouvelle méthode pour centraliser le calcul de taille UIKit
    private func updateLayoutForDynamicType() {
        // 1. Récupérer le ratio actuel
        let ratio = viewSizeRatio
        print(ratio)
        
        // 2. Calculer la nouvelle taille (Base 60 comme dans SwiftUI)
        let newSizeValue = 60 * ratio
        let newSize = CGSize(width: newSizeValue, height: newSizeValue)
        
        // 3. Mettre à jour la frame
        // On garde le centre actuel pour éviter que l'annotation ne "saute" visuellement
        let oldCenter = self.center
        self.frame.size = newSize
        // Sur une MKAnnotationView, MapKit gère souvent le positionnement,
        // mais définir la taille suffit généralement.
        
        // 4. Mettre à jour le corner radius (Base / 3.0 comme dans SwiftUI)
        let newCornerRadius = newSizeValue / 3.0
        self.layer.cornerRadius = newCornerRadius
        backgroundGradient.cornerRadius = newCornerRadius
        
        // 5. Mettre à jour le background layer
        backgroundGradient.frame = self.bounds
        
        // 6. Mettre à jour la font si nécessaire (déjà fait dans prepareForDisplay, mais utile pour traitCollectionDidChange)
        if let currentText = countryCountLabel.text, !currentText.isEmpty {
            countryCountLabel.font = UIFont.systemFont(ofSize: 18 * ratio, weight: .semibold)
        }
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
                    font: UIFont.systemFont(ofSize: 17, weight: .semibold),
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
        // return calculateSizeForContent(count: 0)
        return CGSize(width: 60 * viewSizeRatio, height: 60 * viewSizeRatio)
    }
}

#if DEBUG
#Preview("CountryClusterAnnotationView") {
    let annotationView = CountryClusterAnnotationView()
    annotationView.testDisplay(with: 10)
    return annotationView
}
#endif
