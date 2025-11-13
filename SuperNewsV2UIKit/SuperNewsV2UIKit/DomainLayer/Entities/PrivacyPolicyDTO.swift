//
//  PrivacyPolicyDTO.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 22/12/2023.
//

import Foundation

import Foundation

struct PrivacyPolicyDTO: Decodable, Sendable {
    let title: String
    let updateDate: String
    let sections: [PrivacyPolicySectionDTO]
    
    init(with privacyPolicy: PrivacyPolicy) {
        self.title = privacyPolicy.title
        self.updateDate = privacyPolicy.updateDate
        self.sections = privacyPolicy.sections.map { PrivacyPolicySectionDTO(with: $0) }
    }
}

struct PrivacyPolicySectionDTO: Decodable, Sendable {
    let subtitle: String
    let content: String
    
    init(with section: PrivacyPolicySection) {
        self.subtitle = section.subtitle
        self.content = section.content
    }
}

extension PrivacyPolicyDTO {
    static func getFakeObjectFromPrivacyPolicy() -> PrivacyPolicyDTO {
        return PrivacyPolicyDTO(with: PrivacyPolicy.getFakePrivacyPolicy())
    }
}
