//
//  CountryClusterAnnotationGlassView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 09/11/2025.
//

import SwiftUI

@available(iOS 26.0, *)
struct CountryClusterAnnotationGlassView: View {
    let count: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(count)")
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
        }
        .frame(width: 60, height: 60)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 20))
    }
}

@available(iOS 26.0, *)
#Preview {
    CountryClusterAnnotationGlassView(count: 0)
}
