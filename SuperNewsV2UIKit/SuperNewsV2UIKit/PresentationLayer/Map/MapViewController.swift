//
//  MapViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 20/05/2023.
//

import UIKit
import MapKit
import CoreLocation
import Combine
import SnapKit

final class MapViewController: UIViewController {
    // MVVM with Reactive Programming
    var viewModel: MapViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    let annotationViewModels: [CountryAnnotationViewModel] = [
        CountryAnnotationViewModel(countryName: "France", countryCode: "fr", coordinates: CLLocationCoordinate2D(latitude: 48.861066, longitude: 2.340169)),
        CountryAnnotationViewModel(countryName: "Émirats Arabes Unis", countryCode: "ae", coordinates: CLLocationCoordinate2D(latitude: 24.453835, longitude: 54.377401)),
        CountryAnnotationViewModel(countryName: "Belgique", countryCode: "be", coordinates: CLLocationCoordinate2D(latitude: 50.846557, longitude: 4.351697)),
        CountryAnnotationViewModel(countryName: "Allemagne", countryCode: "de", coordinates: CLLocationCoordinate2D(latitude: 52.517037, longitude: 13.38886))
    ]
    
    // Background
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let blue = UIColor(named: "SuperNewsBlue")?.cgColor ?? UIColor.blue.cgColor
        let darkBlue = UIColor(named: "SuperNewsDarkBlue")?.cgColor ?? UIColor.black.cgColor
        gradient.type = .axial
        gradient.colors = [
            blue,
            darkBlue,
            darkBlue,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.25, 0.5, 1]
        return gradient
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(CountryAnnotationView.self, forAnnotationViewWithReuseIdentifier: "countryAnnotation")
        mapView.register(CountryClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: "countryCluster")

        return mapView
    }()
    
    // For searching news
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Rechercher"
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        return searchBar
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setViewBackground()
        buildViewHierarchy()
        setConstraints()
        setBindings()
        
        viewModel?.loadCountries()
        viewModel?.getLocation()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(mapView)
        mapView.addSubview(searchBar)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func setBindings() {
        viewModel?.userLocationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("OK: done")
                case .failure(let error):
                    print(error.rawValue)
                    // Default position set in Paris
                    self?.centerMapToPosition(with: CLLocation(latitude: 48.866667, longitude: 2.333333), and: 1000000)
                }
            } receiveValue: { [weak self] location in
                print("[MapViewController] Location succeeded")
                self?.centerMapToPosition(with: location, and: 10000)
            }.store(in: &subscriptions)
        
        viewModel?.countryAnnotationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loaded in
                if loaded {
                    self?.placeAnnotations()
                }
            }.store(in: &subscriptions)
    }
}

extension MapViewController {
    private func setViewBackground() {
        backgroundGradient.frame = view.bounds
        view.layer.addSublayer(backgroundGradient)
    }
    
    private func placeAnnotations() {
        let annotationViewModels = viewModel?.getAnnotationViewModels() ?? []
        
        for viewModel in annotationViewModels {
            let annotation = CountryPointAnnotation(viewModel: viewModel)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func centerMapToPosition(with location: CLLocation, and radius: CLLocationDistance) {
        // Set a visible region in meters
        let regionRadius = radius
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // User position on map: blue dot
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        guard let countryAnnotation = annotation as? CountryPointAnnotation,
            let annotationViewModel = countryAnnotation.viewModel else {
            // Cluster of countries annotations
            return CountryClusterAnnotationView(annotation: annotation, reuseIdentifier: "countryCluster")
        }
        
        // Single country annotation
        let annotationView = CountryAnnotationView(annotation: countryAnnotation, reuseIdentifier: "countryAnnotation")
        annotationView.configure(with: annotationViewModel)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is CountryClusterAnnotationView {
            print("Cluster selected")
        } else {
            print("Country annotation selected")
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // viewModel?.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // viewModel?.searchQuery = ""
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MapViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let tabBar = GradientTabBarController()
                let navigationController = UINavigationController()
                let builder = MapModuleBuilder()
                let vc = builder.buildModule(testMode: true)
                vc.tabBarItem = UITabBarItem(title: "Carte du monde", image: UIImage(systemName: "map"), tag: 0)
                navigationController.pushViewController(vc, animated: false)
                // vc.navigationController?.navigationBar.isHidden = true
                tabBar.viewControllers = [navigationController]
                
                return tabBar
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName(deviceName)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
