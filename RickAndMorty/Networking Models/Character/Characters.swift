//
//  Characters.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation

// MARK: - Welcome

struct Characters: Codable {
    let info: InfoCharacters
    let results: [NetworkingCharacter]
}


