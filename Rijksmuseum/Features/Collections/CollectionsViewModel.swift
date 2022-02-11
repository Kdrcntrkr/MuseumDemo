//
//  CollectionsViewModal.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import Foundation

class CollectionsViewModel {
    private let networkController: NetworkManager
    private var pageNumber = 1
    var dataSource: CollectionsDataSource
    
    init(networkController: NetworkManager,
                  dataSource: CollectionsDataSource) {
        self.networkController = networkController
        self.dataSource = dataSource
    }
    
    func fetchCollections(handler: @escaping (FetchCollections.Response?, NetworkError?) -> Void) {
        let request = FetchCollections.Request(key: "mVSiF51W", query: "a", pageNumber: pageNumber)
        
        networkController.sendRequest(request: .fetchCollections(request)) { result in
            switch result {
            case .success(let response):
                do {
                    let collections = try JSONDecoder().decode(FetchCollections.Response.self, from: response)
                    self.pageNumber = self.pageNumber + 1
                    handler(collections, nil)
                } catch {
                    handler(nil, .parseError)
                }
            case .failure(let err):
                handler(nil, .somethingWentWrong(err))
            }
        }
    }
    
    func getObjectNumber(with index: Int) -> String {
        return dataSource.collections[index].objectNumber
    }
}


