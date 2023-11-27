//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateUI()
    }
    
    // MARK: - Methods

    func configurateUI() {
        title = "Settings"
        view.backgroundColor = Appearance.bgImage
        
        let navigationBarAppearance = Appearance.NavBarAppearance()
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

}
