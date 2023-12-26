//
//  PrivacyPolicy.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 22/12/2023.
//

import Foundation

struct PrivacyPolicy: Decodable {
    let title: String
    let updateDate: String
    let sections: [PrivacyPolicySection]
}

struct PrivacyPolicySection: Decodable {
    let subtitle: String
    let content: String
}

extension PrivacyPolicy {
    static func getFakePrivacyPolicy() -> PrivacyPolicy {
        return PrivacyPolicy(
            title: "SuperNews Privacy Policy",
            updateDate: "2023-12-26",
            sections: [
                PrivacyPolicySection(subtitle: "Information collection", content: "No personal data collected. Only crash data from automatic reports and the information you brought."),
                PrivacyPolicySection(subtitle: "Contact", content: "Contact at supernewsiosapp@gmail.com.")
            ]
        )
    }
}
