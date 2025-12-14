//
//  CountryAnnotationGlassView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 06/11/2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct CountryAnnotationGlassView: View {
    let countryName: String
    let countryCode: String
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private var imageScaleFactor: CGFloat {
        let referenceFontSize: CGFloat = 14 // Taille de base pour .body
        let scaledFontSize = UIFontMetrics.default.scaledValue(for: referenceFontSize)
        
        // Calculer le ratio par rapport à la taille par défaut (17pt pour .body)
        return scaledFontSize / referenceFontSize
    }
    
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
            Text(countryName)
                .font(.system(size: 14 * viewSizeRatio, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Image(countryCode)
                .resizable()
                .frame(width: 48 * imageScaleFactor, height: 32 * imageScaleFactor)
                .scaledToFit()
                .padding(.vertical, 5)
        }
        .frame(width: 100 * viewSizeRatio, height: 100 * viewSizeRatio)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 100 * viewSizeRatio / 3))
    }
}

extension Font {
    static func scalableSystem(size: CGFloat, weight: UIFont.Weight = .regular, textStyle: UIFont.TextStyle = .body) -> Font {
        let uiFont = UIFont.systemFont(ofSize: size, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        return Font(metrics.scaledFont(for: uiFont))
    }
}

@available(iOS 26.0, *)
#Preview {
    CountryAnnotationGlassView(countryName: "Émirats Arabes Unis", countryCode: "ae")
}
