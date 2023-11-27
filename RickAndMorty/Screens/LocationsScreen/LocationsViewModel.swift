//
//  LocationsViewModel.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import Foundation

class LocationsViewModel {
    
    @Published private(set) var data: [String:[Location]] = [:]
    private var workItem: DispatchWorkItem?
    private var apiManager = APIManager()
    
    func setData(data: [String:[Location]]) {
        self.data = data
    }
    
    func cancelWorkItem() {
        workItem?.cancel()
    }
    
    func getLocations() {
        var localData: [String:[Location]] = [:]
        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            for page in 1...7 {
                var fetchedEpisodesCount = 0
                self.apiManager.getLocations(page: page) { [weak self] locations in
                    guard let self = self else { return }
                    for elem in locations {
                        fetchedEpisodesCount += 1
                        let new = Location(
                            id: elem.id,
                            name: elem.name,
                            type: elem.type == "" ? "unknown" : elem.type,
                            dimension: elem.dimension,
                            residents: elem.residents,
                            url: elem.url,
                            created: elem.created
                        )
                        if localData[new.type] != nil {
                            localData[new.type]?.append(new)
                        }
                        else {
                            localData[new.type] = [new]
                        }
                    }
                    if fetchedEpisodesCount == locations.count && page == 7 {
                        DispatchQueue.main.async {
                            self.data = localData
                        }
                    }
                }
            }
        }
        if let item = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
        }
    }
}
