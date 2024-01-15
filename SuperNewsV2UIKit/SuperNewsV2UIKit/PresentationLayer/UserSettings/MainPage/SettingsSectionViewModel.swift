//
//  SettingsSectionViewModel.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 02/08/2023.
//

import Foundation

// Il y a méprise dans le naming :
// Il s'agit d'un Model et non d'un ViewModel
// Le modèle est la structure de données, le ViewModel est l'articulation entre la View et le Model

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
