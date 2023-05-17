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
    // Asynchronous image download.
    func loadImage(with url: String) {
        self.image = nil
        let defaultImage = UIImage(named: "SuperNewsNotAvailableImage")
        var urlComponents = url.split(separator: "/", omittingEmptySubsequences: true)
        
        // In order to download images if the image URL target uses http scheme instead of https, due to ATS restrictions
        if urlComponents.count > 0 {
            urlComponents[0] = "https:/"
        }
        
        guard !url.isEmpty, let imageURL = URL(string: urlComponents.joined(separator: "/")) else {
            self.image = defaultImage
            return
        }
        
        let resource = ImageResource(downloadURL: imageURL)
        self.kf.indicatorType = .activity // Download indicator
        self.kf.setImage(with: resource, placeholder: nil, options: [.transition(.fade(0.5))])
    }
    
    // Needed to optimize performances while scrolling the TableView
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }
}
