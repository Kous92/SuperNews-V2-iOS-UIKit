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
    private func defaultPlaceholderImage() -> UIImage {
        return Locale.current.languageCode == "fr" ? UIImage(named: "SuperNewsNotAvailableImageFR")! : UIImage(named: "SuperNewsNotAvailableImageEN")!
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
        self.kf.setImage(with: imageURL, placeholder: nil, options: [.transition(.fade(0.5))])
    }
    
    // Needed to optimize performances while scrolling the TableView
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }
}
