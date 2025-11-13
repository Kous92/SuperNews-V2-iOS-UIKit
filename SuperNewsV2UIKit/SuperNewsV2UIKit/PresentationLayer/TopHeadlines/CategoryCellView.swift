//
//  CategoryCellView.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 01/11/2025.
//

import SwiftUI
import Observation

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

@Observable final class CellState {
    var isSelected: Bool = false
}

struct CategoryCellView: View {
    let title: String
    var state: CellState
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Text(title)
                .padding(12)
                .foregroundStyle(state.isSelected ? .white : .gray)
                .if(state.isSelected) { view in
                    view.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                }
                .padding(7)
                // .animation(.easeInOut(duration: 0.2), value: state.isSelected)
        } else {
            Text(title)
                .padding(12)
                .foregroundStyle(state.isSelected ? .white : .gray)
                .padding(7)
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        CategoryCellView(title: "Top Headlines", state: CellState())
    }
}
