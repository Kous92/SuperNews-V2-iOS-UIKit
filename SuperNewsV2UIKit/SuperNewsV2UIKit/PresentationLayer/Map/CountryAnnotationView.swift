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
    
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = getGradient2()
        gradient.type = .axial
        gradient.cornerRadius = 35
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
    
    // MARK: - SwiftUI hosting (no @available here)
    private var hostingController: AnyObject?
    
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
        layer.cornerRadius = 35
        
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
            make.width.height.equalTo(100)
        }
        
        hostingController = hc
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
        
        if #available(iOS 26.0, *) {
            if let hc = hostingController as? UIHostingController<CountryAnnotationGlassView> {
                hc.rootView = CountryAnnotationGlassView(
                    countryName: viewModel.countryName,
                    countryCode: viewModel.countryCode
                )
            }
        } else {
            countryNameLabel.setShadowLabel(string: viewModel.countryName, font: UIFont.systemFont(ofSize: 12, weight: .medium), shadowColor: .blue, radius: 3)
            flagImageView.image = UIImage(named: viewModel.countryCode)
        }
    }
    
    // For live preview
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
}

#if canImport(SwiftUI) && DEBUG
#Preview("CountryAnnotationView") {
    let annotationView = CountryAnnotationView()
    annotationView.configure(with: CountryAnnotationViewModel(countryName: "Émirats Arabes Unis", countryCode: "ae", coordinates: CLLocationCoordinate2D(latitude: 48.861066, longitude: 2.340169)))
    return annotationView
}
#endif
