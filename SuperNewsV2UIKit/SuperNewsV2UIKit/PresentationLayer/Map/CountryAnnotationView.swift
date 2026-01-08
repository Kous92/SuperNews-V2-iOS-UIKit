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
import SwiftUI

final class CountryAnnotationView: MKAnnotationView {
    private(set) var viewModel: CountryAnnotationViewModel?
    
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
            return 1.9
        case .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge: // Equivalent 3, 4, 5
            return 2.2
        default:
            return 1.0
        }
    }
    
    private var imageScaleFactor: CGFloat {
        let category = traitCollection.preferredContentSizeCategory
        
        if category == .extraSmall || category == .small || category == .medium || category == .large || category == .extraLarge {
            return 1.0
        }
        
        let referenceFontSize: CGFloat = 17 // Basic size of .body
        let scaledFontSize = UIFontMetrics.default.scaledValue(for: referenceFontSize)
        
        // Calculer le ratio par rapport à la taille par défaut (17pt pour .body)
        return scaledFontSize / referenceFontSize
    }
    
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = getGradient2()
        gradient.type = .axial
        gradient.cornerRadius = (110 * viewSizeRatio) / 3
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
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - SwiftUI hosting (no @available here)
    private var hostingController: AnyObject?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "countryCluster"
        
        // Detect any size category change with Dynamic Type
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            
            // Si la catégorie de taille de contenu a changé
            if self.traitCollection.preferredContentSizeCategory != previousTraitCollection.preferredContentSizeCategory {
                print("Change size, current ratio: \(self.viewSizeRatio), image scale \(self.imageScaleFactor):")
                // On force le redessin si on est en mode UIKit pur
                if #unavailable(iOS 26.0) {
                    self.updateLayoutForDynamicType()
                }
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultHigh
        frame = CGRect(x: 0, y: 0, width: 110 * viewSizeRatio, height: 110 * viewSizeRatio)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        layer.cornerRadius = (110 * viewSizeRatio) / 3
        
        self.annotationView.accessibilityIdentifier = "annotation\(viewModel?.countryCode ?? "??")"
        
        /*
        - iOS 26.0 and later: use SwiftUI view with Liquid Glass
        - iOS < 26 : keep the classic UIKit view
        */
        if #available(iOS 26.0, *) {
            applySwiftUIView()
        } else {
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            setViewBackground()
            buildViewHierarchy()
            setConstraints()
        }
    }
    
    // MARK: - SwiftUI integration
    @available(iOS 26.0, *)
    private func applySwiftUIView() {
        // Remove UIKit fallback layers
        annotationView.removeFromSuperview()
        backgroundGradient.removeFromSuperlayer()
        flagImageView.removeFromSuperview()
        countryNameLabel.removeFromSuperview()
        
        // Clear any previous hosting view
        (hostingController as? UIViewController)?.view.removeFromSuperview()
        hostingController = nil
        
        // Create SwiftUI view dynamically
        let name = viewModel?.countryName ?? ""
        let code = viewModel?.countryCode ?? ""
        
        let swiftUIView = CountryAnnotationGlassView(
            countryName: name,
            countryCode: code
        )
        
        let hc = UIHostingController(rootView: swiftUIView)
        hc.view.backgroundColor = .clear
        hc.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hc.view)
        hc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(110)
        }
        
        hostingController = hc
    }
    
    // Nouvelle méthode pour centraliser le calcul de taille UIKit
    private func updateLayoutForDynamicType() {
        // 1. Récupérer le ratio actuel
        print(viewSizeRatio)
        let newSizeValue = 110 * viewSizeRatio
        
        // 2. Calculer la nouvelle taille (Base 100 comme dans SwiftUI)
        let newSize = CGSize(width: newSizeValue, height: newSizeValue)
        
        // 3. Mettre à jour la frame
        // On garde le centre actuel pour éviter que l'annotation ne "saute" visuellement
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
        /*
        if let currentText = countryCountLabel.text, !currentText.isEmpty {
            countryCountLabel.font = UIFont.systemFont(ofSize: 18 * ratio, weight: .semibold)
        }
        */
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
            make.height.equalTo(32 * imageScaleFactor)
            make.width.equalTo(44 * imageScaleFactor)
            make.centerX.equalTo(annotationView)
            make.top.equalTo(countryNameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setViewBackground() {
        backgroundGradient.frame = self.bounds
        self.layer.addSublayer(backgroundGradient)
    }
    
    /// Fills a NewsTableViewCell with title, source and image data from a ViewModel.
    func configure(with viewModel: CountryAnnotationViewModel) {
        self.viewModel = viewModel
        
        if #available(iOS 26.0, *) {
            if let hc = hostingController as? UIHostingController<CountryAnnotationGlassView> {
                hc.rootView = CountryAnnotationGlassView(
                    countryName: viewModel.countryName,
                    countryCode: viewModel.countryCode
                )
            }
        } else {
            setViewBackground()
            countryNameLabel.setShadowLabel(string: viewModel.countryName, font: UIFont.systemFont(ofSize: 15, weight: .medium), shadowColor: .blue, radius: 3)
            flagImageView.image = UIImage(named: viewModel.countryCode)
        }
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 110 * viewSizeRatio, height: 110 * viewSizeRatio)
     
    }
}

#if canImport(SwiftUI) && DEBUG
#Preview("CountryAnnotationView") {
    let annotationView = CountryAnnotationView()
    annotationView.configure(with: CountryAnnotationViewModel(countryName: "Émirats Arabes Unis", countryCode: "ae", coordinates: CLLocationCoordinate2D(latitude: 48.861066, longitude: 2.340169)))
    return annotationView
}
#endif
