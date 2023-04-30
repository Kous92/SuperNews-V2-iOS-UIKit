//
//  ArrayExtensions.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/04/2023.
//

import Foundation

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removeDuplicates()
    }
}
