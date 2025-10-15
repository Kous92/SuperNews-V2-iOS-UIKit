//
//  ImageLoader.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 24/04/2023.
//

import UIKit
import Kingfisher

// With Kingfisher, it's asynchronous, fast and efficient. Cache is managed automatically.
extension UIImageView {
    func defaultPlaceholderImage() -> UIImage {
        return Locale.current.language.languageCode?.identifier == "fr" ? UIImage(named: "SuperNewsNotAvailableImageFR")! : UIImage(named: "SuperNewsNotAvailableImageEN")!
    }
    
    // Asynchronous image download.
    func loadImage(with url: String) {
        self.image = nil
        let defaultImage = defaultPlaceholderImage()
        
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            self.image = defaultImage
            return
        }
        
        self.kf.indicatorType = .activity // Download indicator
        
        // It might have server issues, if link is valid, but resource is not found. Investigate here !!!
        self.kf.setImage(with: imageURL, placeholder: nil, options: [.transition(.fade(0.5))])
        
        // In case of 404 error from server URL, replace with placeholder image.
        if self.image == nil {
            self.image = defaultImage
        }
    }
    
    // Needed to optimize performances while scrolling the TableView
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }
}
