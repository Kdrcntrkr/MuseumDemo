//
//  CollectionDetailsViewModel.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 2.07.2021.
//

import Foundation

class CollectionDetailsViewModel {
    let networkController: NetworkManager
    
    init(networkController: NetworkManager) {
        self.networkController =  networkController
    }
    
    func fetchDetails(with objectNumber: String, handler: @escaping (FetchDetails.Response?, NetworkError?) -> Void) {
        let request = FetchDetails.Request(key: "mVSiF51W", objectNumber: objectNumber)
        
        networkController.sendRequest(request: .fetchDetails(request)) { result in
            switch result {
            case .success(let response):
                do {
                    let details = try JSONDecoder().decode(FetchDetails.Response.self, from: response)
                    handler(details, nil)
                } catch {
                    handler(nil, .parseError)
                }
            case .failure(let err):
                handler(nil, .somethingWentWrong(err))
            }
        }
    }
}
