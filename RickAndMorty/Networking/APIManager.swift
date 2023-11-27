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
    let urlEpisodesString = "https://rickandmortyapi.com/api/episode/?page="
    let urlLocationsString = "https://rickandmortyapi.com/api/location/?page="
    
    func getCharacters(page: Int, completion: @escaping (_ data: [NetworkingCharacter]) -> Void) {
        guard let url = URL(string: urlCharactersString + String(page)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let charactersData = try? JSONDecoder().decode(Characters.self, from: data) {
                completion(charactersData.results)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
    
    func getEpisodes(page: Int, completion: @escaping (_ data: [NetworkingEpisode]) -> Void) {
        guard let url = URL(string: urlEpisodesString + String(page)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let episodesData = try? JSONDecoder().decode(Episodes.self, from: data) {
                completion(episodesData.results)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
    
    func getLocations(page: Int, completion: @escaping (_ data: [NetworkingLocation]) -> Void) {
        guard let url = URL(string: urlLocationsString + String(page)) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            if let episodesData = try? JSONDecoder().decode(Locations.self, from: data) {
                completion(episodesData.results)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
    
    func getImage(characterImage: String, completion: @escaping (_ data: Data) -> Void) {
        guard let url = URL(string: characterImage) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response, error in
            guard response != nil else { return }
            guard let data else {return}
            completion(data)
        }
        task.resume()
    }
}
