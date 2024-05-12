//
//  SuperNewsCoordinatorTests.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 17/04/2023.
//

import XCTest
@testable import SuperNewsV2UIKit

final class SuperNewsCoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coordinator = AppCoordinator(with: GradientTabBarController())
    }
    
    func testAppCoordinatorRootViewController() {
        let viewController = coordinator?.start()
        XCTAssertTrue(viewController is GradientTabBarController)
        
        if let gradientTabBar = viewController as? GradientTabBarController {
            XCTAssertEqual(gradientTabBar.tabBar.items?.count ?? 0, 4)
        } else {
            XCTFail()
        }
    }
    
    func testTopHeadlinesCoordinator() {
        let topHeadlinesCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder(), testMode: true)
        let navigationController = topHeadlinesCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] is TopHeadlinesViewController)
    }
    
    func testTopHeadlinesChildCoordinator() {
        let topHeadlinesCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder(), testMode: true)
        
        topHeadlinesCoordinator.goToSourceSelectionView()
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 1)
        
        topHeadlinesCoordinator.goToDetailArticleView(with: ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle()))
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 2)
    }
    
    func testSourceSelectionCoordinator() {
        let sourceSelectionCoordinator = SourceSelectionCoordinator(navigationController: UINavigationController(), builder: SourceSelectionModuleBuilder(), testMode: true)
        let navigationController = sourceSelectionCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is SourceSelectionViewController)
    }
    
    func testSourceSelectionBackToPreviousScreen() {
        let topHeadlinesCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder(), testMode: true)
        let navigationController = topHeadlinesCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        XCTAssertEqual(topHeadlinesCoordinator.navigationController.viewControllers.count, 1)
        
        topHeadlinesCoordinator.goToSourceSelectionView()
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(topHeadlinesCoordinator.childCoordinators[0] is SourceSelectionCoordinator)
        
        guard let sourceSelectionCoordinator = topHeadlinesCoordinator.childCoordinators[0] as? SourceSelectionCoordinator else {
            XCTFail("The Coordinator is not a SourceSelectionCoordinator as required for this test.")
            
            return
        }
        
        weak var delegate: SourceSelectionViewControllerDelegate? = sourceSelectionCoordinator
        delegate?.backToHomeView()
        
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 0)
    }
    
    func testArticleDetailCoordinator() {
        let viewModel = ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle())
        let moduleBuilder = ArticleDetailModuleBuilder(articleViewModel: viewModel)
        let articleDetailCoordinator = ArticleDetailCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = articleDetailCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is ArticleDetailViewController)
    }
    
    func testArticleDetailBackToPreviousScreen() {
        let topHeadlinesCoordinator = TopHeadlinesCoordinator(navigationController: UINavigationController(), builder: TopHeadlinesModuleBuilder(), testMode: true)
        let navigationController = topHeadlinesCoordinator.start()
        XCTAssertTrue(navigationController is UINavigationController)
        
        topHeadlinesCoordinator.goToDetailArticleView(with: ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle()))
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(topHeadlinesCoordinator.childCoordinators[0] is ArticleDetailCoordinator)
        
        guard let articleDetailCoordinator = topHeadlinesCoordinator.childCoordinators[0] as? ArticleDetailCoordinator else {
            XCTFail("The Coordinator is not a ArticleDetailCoordinator as required for this test.")
            
            return
        }
        
        weak var delegate: ArticleDetailViewControllerDelegate? = articleDetailCoordinator
        delegate?.backToPreviousScreen()
        
        XCTAssertEqual(topHeadlinesCoordinator.childCoordinators.count, 0)
    }
    
    func testSearchCoordinator() {
        let moduleBuilder = SearchModuleBuilder()
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = searchCoordinator.start()
        
        XCTAssertTrue(navigationController is UINavigationController)
        
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is SearchViewController)
    }
    
    func testSearchChildCoordinator() {
        let moduleBuilder = SearchModuleBuilder()
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        
        searchCoordinator.goToDetailArticleView(with: ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle()))
        XCTAssertEqual(searchCoordinator.childCoordinators.count, 1)
    }
    
    func testMapCoordinator() {
        let moduleBuilder = MapModuleBuilder()
        let mapCoordinator = MapCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = mapCoordinator.start()
        
        XCTAssertTrue(navigationController is UINavigationController)
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is MapViewController)
    }
    
    func testMapChildCoordinator() {
        let moduleBuilder = MapModuleBuilder()
        let mapCoordinator = MapCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        
        mapCoordinator.goToCountryNewsView(countryCode: "fr")
        XCTAssertEqual(mapCoordinator.childCoordinators.count, 1)
    }
    
    func testCountryNewsCoordinator() {
        let moduleBuilder = CountryNewsModuleBuilder(countryCode: "fr")
        let countryNewsCoordinator = CountryNewsCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = countryNewsCoordinator.start()
        
        XCTAssertTrue(navigationController is UINavigationController)
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is CountryNewsViewController)
    }
    
    func testCountryNewsChildCoordinator() {
        let moduleBuilder = CountryNewsModuleBuilder(countryCode: "fr")
        let countryNewsCoordinator = CountryNewsCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        
        countryNewsCoordinator.goToDetailArticleView(with: ArticleViewModel(with: ArticleDTO.getFakeObjectFromArticle()))
        XCTAssertEqual(countryNewsCoordinator.childCoordinators.count, 1)
    }
    
    func testSettingsCoordinator() {
        let moduleBuilder = SettingsModuleBuilder()
        let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        
        settingsCoordinator.goToSettingsSelectionView(settingSection: .newsCountry)
        XCTAssertEqual(settingsCoordinator.childCoordinators.count, 1)
    }
    
    func testSettingsSelectionCoordinator() {
        let moduleBuilder = SettingsSelectionModuleBuilder(settingSection: .newsCountry)
        let settingsSelectionCoordinator = SettingsSelectionCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = settingsSelectionCoordinator.start()
        
        XCTAssertTrue(navigationController is UINavigationController)
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is SettingsSelectionViewController)
    }
    
    func testPrivacyPolicyCoordinator() {
        let moduleBuilder = PrivacyPolicyModuleBuilder()
        let privacyPolicyCoordinator = PrivacyPolicyCoordinator(navigationController: UINavigationController(), builder: moduleBuilder, testMode: true)
        let navigationController = privacyPolicyCoordinator.start()
        
        XCTAssertTrue(navigationController is UINavigationController)
        guard let navigationController = navigationController as? UINavigationController else {
            XCTFail("The ViewController is not a UINavigationController as required for this test.")
            
            return
        }
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        print(navigationController.viewControllers)
        XCTAssertTrue(navigationController.viewControllers[0] is PrivacyPolicyViewController)
    }
}
