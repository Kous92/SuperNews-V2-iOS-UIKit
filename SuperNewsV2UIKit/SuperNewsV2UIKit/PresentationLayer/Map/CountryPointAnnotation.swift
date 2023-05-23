//
//  CountryPointAnnotation.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 22/05/2023.
//

import Foundation
import MapKit
import CoreLocation

final class CountryPointAnnotation: NSObject, MKAnnotation {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var viewModel: CountryAnnotationViewModel?
    
    init(viewModel: CountryAnnotationViewModel) {
        self.coordinate = viewModel.coordinates
        self.viewModel = viewModel
    }
    
    func configure(with viewModel: CountryAnnotationViewModel) {
        self.viewModel = viewModel
        self.coordinate = viewModel.coordinates
    }
}
