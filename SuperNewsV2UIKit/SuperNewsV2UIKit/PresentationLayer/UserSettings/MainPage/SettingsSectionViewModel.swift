//
//  SettingsSectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/08/2023.
//

import Foundation

struct SettingsSectionViewModel {
    let description: String
    let detail: String
    private let section: SettingsSection
    
    init(with section: SettingsSection) {
        self.section = section
        self.description = section.description
        self.detail = section.detail
    }
    
    func getSettingSection() -> SettingsSection {
        return section
    }
}
