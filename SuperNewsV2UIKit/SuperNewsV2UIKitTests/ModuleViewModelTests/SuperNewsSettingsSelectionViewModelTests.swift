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
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: SettingsSelectionViewModel?
    private var viewModel2: SettingsSelectionViewModel?
    private var sectionName1 = ""
    private var sectionName2 = ""
    private var fulfilledCount = 0
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let userSettingsRepository1 = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "language"))
        let userSettingsRepository2 = SuperNewsUserSettingsRepository(settingsService: SuperNewsMockCountryLanguageSettings(with: "country"))
        let localFileRepository = SuperNewsJSONFileRepository(localFileService: SuperNewsMockFileService(forceLoadFailure: false))
        
        let userSettingsUseCase = UserSettingsUseCase(localFileRepository: localFileRepository)
        let loadUserSettingsUseCase1 = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository1)
        let loadUserSettingsUseCase2 = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository2)
        let saveUserSettingsUseCase = SaveUserSettingsUseCase(userSettingsRepository: userSettingsRepository1)
        
        viewModel = SettingsSelectionViewModel(settingSection: .newsLanguage, userSettingsUseCase: userSettingsUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase1, saveUserSettingsUseCase: saveUserSettingsUseCase)
        viewModel2 = SettingsSelectionViewModel(settingSection: .newsCountry, userSettingsUseCase: userSettingsUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase2, saveUserSettingsUseCase: saveUserSettingsUseCase)
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
        XCTAssertEqual(sectionName1, String(localized: "newsLanguage"))
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
        XCTAssertEqual(sectionName2, String(localized: "newsCountry"))
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
        XCTAssertEqual(index, 1)
        
        
        let cellViewModel = try XCTUnwrap(viewModel?.getCellViewModel(at: IndexPath(row: 2, section: 0)))
        XCTAssertEqual(cellViewModel.name, String(localized: "french"))
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
        XCTAssertEqual(cellViewModel.name, cellViewModel.code.countryName())
    }
    
    func testSaveLanguageSettingOption() {
        let expectation5 = XCTestExpectation(description: "Load settings language choices")
        
        // The binding before executing the loading of data.
        viewModel?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                if updated {
                    print("Fulfilled")
                    self?.fulfilledCount += 1
                    
                    if self?.fulfilledCount == 1 {
                        self?.viewModel?.saveSelectedSetting(at: IndexPath(row: 0, section: 0))
                    } else if self?.fulfilledCount == 2 {
                        if let index = self?.viewModel?.getActualSelectedIndex() {
                            print("Index = \(index)")
                            XCTAssertEqual(index, 0)
                            
                            if let vm = self?.viewModel?.getCellViewModel(at: IndexPath(row: 0, section: 0)) {
                                XCTAssertEqual(vm.flagCode, "sa")
                                XCTAssertEqual(vm.name, "Arabic")
                                XCTAssertEqual(vm.code, "ar")
                            }
                        } else {
                            XCTFail()
                        }
                        
                        expectation5.fulfill()
                    }
                }
            }.store(in: &subscriptions)
        
        viewModel?.loadCountryLanguageOptions()
        wait(for: [expectation5], timeout: 10)
    }
    
    func testSaveCountrySettingOption() {
        let expectation6 = XCTestExpectation(description: "Load settings country choices")
        
        // The binding before executing the loading of data.
        viewModel2?.updateResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updated in
                if updated {
                    print("Fulfilled")
                    self?.fulfilledCount += 1
                    
                    if self?.fulfilledCount == 1 {
                        self?.viewModel2?.saveSelectedSetting(at: IndexPath(row: 0, section: 0))
                    } else if self?.fulfilledCount == 2 {
                        if let index = self?.viewModel2?.getActualSelectedIndex() {
                            print("Index = \(index)")
                            XCTAssertEqual(index, 0)
                            
                            if let vm = self?.viewModel2?.getCellViewModel(at: IndexPath(row: 0, section: 0)) {
                                XCTAssertEqual(vm.flagCode, "dz")
                                XCTAssertEqual(vm.name, "Algeria")
                                XCTAssertEqual(vm.code, "dz")
                            }
                        } else {
                            XCTFail()
                        }
                        
                        expectation6.fulfill()
                    }
                }
            }.store(in: &subscriptions)
        
        viewModel2?.loadCountryLanguageOptions()
        wait(for: [expectation6], timeout: 10)
    }
}
