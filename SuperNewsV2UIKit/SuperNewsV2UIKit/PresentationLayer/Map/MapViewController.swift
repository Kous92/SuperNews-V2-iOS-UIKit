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
    
    private lazy var countryAutoCompletionTableView: UITableView = {
        let tableView = UITableView()
        // tableView.backgroundColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.register(CountryAutoCompletionTableViewCell.self, forCellReuseIdentifier: "autoCompletionCell")
        tableView.isHidden = true
        return tableView
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
        mapView.addSubview(countryAutoCompletionTableView)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        countryAutoCompletionTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(300)
        }
    }
    
    private func setBindings() {
        // Update binding
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                if updated {
                    print("Ready to update autocompletion")
                    self?.updateTableView()
                } else {
                    print("No result found")
                    // self?.displayNoResult()
                }
            }.store(in: &subscriptions)
        
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
        
        // backgroundGradient.frame = countryAutoCompletionTableView.bounds
        // countryAutoCompletionTableView.layer.addSublayer(backgroundGradient)
    }
    
    private func updateTableView() {
        countryAutoCompletionTableView.reloadData()
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
        countryAutoCompletionTableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchQuery = ""
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true)
        countryAutoCompletionTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Autocompletion with: \(viewModel?.numberOfRowsInTableView() ?? 0) rows")
        return viewModel?.numberOfRowsInTableView() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompletionCell", for: indexPath) as? CountryAutoCompletionTableViewCell,
              let autoCompletionViewModel = viewModel?.getAutoCompletionViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: autoCompletionViewModel)
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        return cell
    }
}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        countryAutoCompletionTableView.deselectRow(at: indexPath, animated: false)
        countryAutoCompletionTableView.isHidden = true
        countryAutoCompletionTableView.isHidden = true
        searchBar.resignFirstResponder() // Le clavier disparaît (ce n'est pas automatique de base)
        
        guard let searchCountry = viewModel?.getAutoCompletionViewModel(at: indexPath) else {
            return
        }
        
        searchBar.text = searchCountry.countryName
        
        // Centrer sur le pays en question
        let coordinates = searchCountry.coordinates
        centerMapToPosition(with: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), and: 100000)
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
