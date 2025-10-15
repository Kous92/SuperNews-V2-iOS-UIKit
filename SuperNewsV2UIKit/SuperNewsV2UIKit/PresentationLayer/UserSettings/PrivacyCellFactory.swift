//
//  PrivacyCellFactory.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 25/12/2023.
//

import Foundation
import UIKit

@MainActor final class PrivacyCellFactory {
    static func createCell(with cellIdentifier: PrivacyCellIdentifier, viewModel: PrivacyTableViewModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        switch cellIdentifier {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "privacyHeaderCell", for: indexPath) as? PrivacyHeaderTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.headerViewModel)
            return cell
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "privacyPolicyCell", for: indexPath) as? PrivacyTableViewCell else {
                return UITableViewCell()
            }
            
            // The first cell is the title and date.
            cell.configure(with: viewModel.cellViewModels[indexPath.row - 1])
            return cell
        }
    }
}
