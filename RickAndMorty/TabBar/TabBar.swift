//
//  TabBarController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 25.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: Constant
    
    let titles = [
        "Characters",
        "Episodes",
        "Locations",
        //"Settings"
    ]
    
    let images = [
        UIImage(named: "rick")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "clapper")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "flag")?.withRenderingMode(.alwaysOriginal),
        //UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configurateTab()
    }
    
    // MARK: - Methods
    
    func configurateTab() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .black

        let attributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = attributesNormal

        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        let controllers = [
            UINavigationController(rootViewController: CharactersViewController()),
            UINavigationController(rootViewController: EpisodesViewController()),
            UINavigationController(rootViewController: LocationsViewController()),
            //UINavigationController(rootViewController: SettingsViewController())
        ]
        
        for i in 0..<titles.count {
            controllers[i].navigationItem.largeTitleDisplayMode = .automatic
            controllers[i].navigationBar.prefersLargeTitles = true
            controllers[i].tabBarItem = .init(
                title: titles[i],
                image: images[i],
                tag: i
            )
        }
        
        setViewControllers(controllers, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
