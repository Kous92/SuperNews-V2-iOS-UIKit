//
//  SuperNewsSettingsViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 06/09/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsSettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let userSettingsRepository = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "language"))
        let resetUserSettingsUseCase = ResetUserSettingsUseCase(userSettingsRepository: userSettingsRepository)
        
        viewModel = SettingsViewModel(resetUserSettingsUseCase: resetUserSettingsUseCase)
    }
    
    func testLoadSettingsSections() {
        XCTAssertEqual(viewModel?.numberOfRows() ?? 0, 3)
    }
    
    func testCellViewModel() {
        XCTAssertEqual(viewModel?.getCellViewModel(at: IndexPath(row: 0, section: 0))?.description, "language")
    }
}
