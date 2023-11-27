//
//  Character.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation
import UIKit

// MARK: - Result

struct Character {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: CharacterLocation
    let image: UIImage?
    let episode: [String]
    let url: String
    let created: String
}
