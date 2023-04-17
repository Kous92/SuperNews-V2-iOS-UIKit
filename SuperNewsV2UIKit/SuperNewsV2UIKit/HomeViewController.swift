//
//  HomeViewController.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 12/04/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var dataAPI: SuperNewsDataAPIService?
    weak var coordinator: HomeViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
        dataAPI = SuperNewsNetworkAPIService()
        
        /*
        Task {
            await testFetchSources()
            await testFetchArticles()
        }
         */
    }
    
    func testFetchSources() async {
        guard let dataAPI = dataAPI as? SuperNewsNetworkAPIService else {
            return
        }
        
        let result = await dataAPI.fetchAllNewsSources()
        let result1 = await dataAPI.fetchNewsSources(country: "fr")
        let result2 = await dataAPI.fetchNewsSources(category: "business")
        let result3 = await dataAPI.fetchNewsSources(language: "en")
        
        print("Toutes les sources:\n\(result)\n")
        print("Sources de France:\n\(result1)\n")
        print("Sources business:\n\(result2)\n")
        print("Sources en anglais:\n\(result3)\n")
    }
    
    func testFetchArticles() async {
        guard let dataAPI = dataAPI as? SuperNewsNetworkAPIService else {
            return
        }
        
        let result = await dataAPI.fetchTopHeadlinesNews(countryCode: "fr", category: nil)
        let result1 = await dataAPI.fetchTopHeadlinesNews(countryCode: "us", category: "technology")
        let result2 = await dataAPI.fetchTopHeadlinesNews(sourceName: "abc-news")
        let result3 = await dataAPI.searchNewsFromEverything(with: "PSG", language: "fr", sortBy: "relevancy")
        
        print("Actualités en France:\n\(result)\n")
        print("Actualités tech aux USA:\n\(result1)\n")
        print("Actualités d'ABC News:\n\(result2)\n")
        print("Recherche de PSG en français:\n\(result3)\n")
    }
}
