//
//  CountryClusterAnnotationGlassView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 09/11/2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct CountryClusterAnnotationGlassView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let count: Int
    
    // It will help for Dynamic Type to adjust view frame, text and image frame sizes
    private var viewSizeRatio: CGFloat {
        print(dynamicTypeSize)
        switch dynamicTypeSize {
        case .xSmall, .small, .medium, .large, .xLarge:
            return 1
        case .xxLarge:
            return 1.2
        case .xxxLarge:
            return 1.6
        case .accessibility1, .accessibility2:
            return 2.1
        case .accessibility3, .accessibility4, .accessibility5:
            return 2.6
        @unknown default:
            return 1
        }
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(count)")
                // 3. Utiliser un style de police qui supporte le Dynamic Type
                .font(.system(size: 18 * viewSizeRatio, weight: .semibold))
                .multilineTextAlignment(.center)
                .accessibilityLabel("\(count)")
                .padding(10)
        }
        // 4. Utiliser la taille calculée
        .frame(width: 60 * viewSizeRatio, height: 60 * viewSizeRatio)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 60 * viewSizeRatio / 3.0)) // Ajuster le coin
    }
}

@available(iOS 26.0, *)
#Preview {
    CountryClusterAnnotationGlassView(count: 10)
}
