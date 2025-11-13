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
    
    var body: some View {
        VStack(alignment: .center) {
            Text(countryName)
                .font(.system(size: 12, weight: .medium))
                .multilineTextAlignment(.center)
            
            Image(countryCode)
                .resizable()
                .frame(width: 35, height: 30)
        }
        .frame(width: 100, height: 100)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 35.0))
    }
}

@available(iOS 26.0, *)
#Preview {
    CountryAnnotationGlassView(countryName: "Émirats Arabes Unis", countryCode: "ae")
}
