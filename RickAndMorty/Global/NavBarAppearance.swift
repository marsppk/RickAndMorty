//
//  NavBarAppearance.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation
import UIKit

final class Appearance {
    static let bgImage = UIColor(patternImage: UIImage(named: "bg")!)
    static func NavBarAppearance() -> UINavigationBarAppearance {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .black
        
        let titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "WaltDisneysOldFont-Regular", size: 29),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "WaltDisneysOldFont-Regular", size: 50),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationBarAppearance.titleTextAttributes = titleTextAttributes as [NSAttributedString.Key : Any]
        navigationBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes as [NSAttributedString.Key : Any]
        return navigationBarAppearance
    }
}
