//
//  MockNetworkManager.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import Foundation
@testable import Rijksmuseum

class MockNetworkManager: NetworkManager {
    enum Status { case success, error }
    enum DataType { case collection, details, unknown }
    var status: Status = .success
    var dataType: DataType = .collection
    
    override func sendRequest(request: Request, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        switch status {
        case .success:
            switch dataType {
            case .collection:
                completion(.success(getCollectionData()))
            case .details:
                completion(.success(getDetailsData()))
            case .unknown:
                completion(.success(getUnknownData()))
            }
        case .error:
            completion(.failure(.somethingWentWrong(nil)))
        }
    }
    
    func getCollectionData() -> Data {
        let collection = FetchCollections.Response(artObjects: [FetchCollections.ArtObject(objectNumber: "", title: "", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: ""))])
        let data = try? JSONEncoder().encode(collection)
        return data!
    }
    
    func getDetailsData() -> Data {
        let details = FetchDetails.Response(artObject: FetchDetails.ArtObject(longTitle: "", plaqueDescriptionEnglish: "", webImage: WebImage(url: "")))
        let data = try? JSONEncoder().encode(details)
        return data!
    }
    
    func getUnknownData() -> Data {
        return Data(bytes: [1], count: 1)
    }
}
