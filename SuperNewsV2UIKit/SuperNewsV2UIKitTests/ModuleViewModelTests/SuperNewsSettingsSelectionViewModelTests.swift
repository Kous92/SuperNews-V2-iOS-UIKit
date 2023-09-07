//
//  SuperNewsSettingsSelectionViewModelTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 07/09/2023.
//

import XCTest
import Combine
@testable import SuperNewsV2UIKit

final class SuperNewsSettingsSelectionViewModelTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable> = []
    var viewModel: SettingsSelectionViewModel?
    var viewModel2: SettingsSelectionViewModel?
    var sectionName1 = ""
    var sectionName2 = ""
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let userSettingsRepository = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "language"))
        let userSettingsRepository2 = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "country"))
        let localFileRepository = SuperNewsJSONFileRepository(localFileService: SuperNewsMockFileService(forceLoadFailure: false))
        
        viewModel = SettingsSelectionViewModel(settingSection: .newsLanguage, useCase: UserSettingsUseCase(userSettingsRepository: userSettingsRepository, localFileRepository: localFileRepository))
        viewModel2 = SettingsSelectionViewModel(settingSection: .newsCountry, useCase: UserSettingsUseCase(userSettingsRepository: userSettingsRepository2, localFileRepository: localFileRepository))
    }
    
    func testSettingLanguageSectionName() {
        let expectation1 = XCTestExpectation(description: "Load section name (language)")
        
        // Update binding with language
        viewModel?.settingOptionResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                expectation1.fulfill()
                self?.sectionName1 = name
            }.store(in: &subscriptions)
        
        viewModel?.loadCountryLanguageOptions()
        
        wait(for: [expectation1], timeout: 10)
        XCTAssertEqual(sectionName1, "Langue des news")
    }
    
    func testSettingCountrySectionName() {
        let expectation2 = XCTestExpectation(description: "Load section name (country)")
        
        // Update binding with country
        viewModel2?.settingOptionResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                expectation2.fulfill()
                self?.sectionName2 = name
            }.store(in: &subscriptions)
        
        viewModel2?.loadCountryLanguageOptions()
        
        wait(for: [expectation2], timeout: 10)
        XCTAssertEqual(sectionName2, "Pays des news")
    }
    
    func testSettingLanguageOptions() throws {
        let expectation3 = XCTestExpectation(description: "Load settings language choices")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                if updated {
                    print("Fulfilled")
                    expectation3.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel?.loadCountryLanguageOptions()
        wait(for: [expectation3], timeout: 10)
        XCTAssertGreaterThan(viewModel?.numberOfRowsInTableView() ?? 0, 0)
        
        let index = try XCTUnwrap(viewModel?.getActualSelectedIndex())
        XCTAssertEqual(index, 0)
        
        let cellViewModel = try XCTUnwrap(viewModel?.getCellViewModel(at: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(cellViewModel.name, "French")
    }
    
    func testSettingCountryOptions() throws {
        let expectation4 = XCTestExpectation(description: "Load settings country choices")
        
        // The binding before executing the loading of data.
        viewModel2?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { updated in
                if updated {
                    print("Fulfilled")
                    expectation4.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel2?.loadCountryLanguageOptions()
        wait(for: [expectation4], timeout: 10)
        XCTAssertGreaterThan(viewModel2?.numberOfRowsInTableView() ?? 0, 0)
        
        let index = try XCTUnwrap(viewModel?.getActualSelectedIndex())
        XCTAssertEqual(index, 0)
        
        let cellViewModel = try XCTUnwrap(viewModel2?.getCellViewModel(at: IndexPath(row: 2, section: 0)))
        XCTAssertEqual(cellViewModel.name, "Algeria")
    }
}