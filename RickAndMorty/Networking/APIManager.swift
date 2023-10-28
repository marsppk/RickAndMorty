//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation


final class APIManager {
    static let shared = APIManager()
    
    let urlCharactersString = "https://rickandmortyapi.com/api/character/?page="
    
    func getCharacters(page: Int, completion: @escaping (_ data: [Result]) -> Void) {
        guard let url = URL(string: urlCharactersString + String(page)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let charactersData = try? JSONDecoder().decode(Welcome.self, from: data) {
                completion(charactersData.results)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
    
    func getImage(character: Result, completion: @escaping (_ data: Data) -> Void) {
        guard let url = URL(string: character.image) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            completion(data)
        }
        task.resume()
    }
}
