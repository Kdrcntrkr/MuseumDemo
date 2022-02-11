//
//  NetworkManager.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 1.07.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func sendRequest(request: Request, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        
        guard var urlComponents = URLComponents(string: request.baseURL) else { return completion(.failure(.urlFailure))}
        urlComponents.queryItems = request.parameters
        guard let requestUrl = urlComponents.url else {
            return completion(.failure(.urlFailure))
        }
        
        let request = URLRequest(url: requestUrl)
        
        let task = urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                return completion(.failure(.somethingWentWrong(error)))
            }
            guard let data = data, !data.isEmpty else {
                return completion(.failure(.noData))
            }
            completion(.success(data))
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case noData
    case somethingWentWrong(Error?)
    case parseError
    case urlFailure
}

protocol RequestProtocol {
    var parameters: [URLQueryItem] { get}
}


internal enum Request {
    case fetchCollections(FetchCollections.Request)
    case fetchDetails(FetchDetails.Request)
    
    var parameters: [URLQueryItem] {
        switch self {
        case .fetchCollections(let request):
            var items = [URLQueryItem]()
            items.append(URLQueryItem(name: "key", value: request.key))
            items.append(URLQueryItem(name: "q", value: request.query))
            items.append(URLQueryItem(name: "ps", value: "10"))
            items.append(URLQueryItem(name: "p", value: String(request.pageNumber)))
            return items
        case .fetchDetails(let request):
            var items = [URLQueryItem]()
            items.append(URLQueryItem(name: "key", value: request.key))
            return items
        }
    }
    
    var baseURL: String {
        switch self {
        case .fetchCollections:
            return "https://www.rijksmuseum.nl/api/en/collection/"
        case .fetchDetails(let request):
            return "https://www.rijksmuseum.nl/api/en/collection/\(request.objectNumber)"
        }
    }
    
    var method: String {
        return "GET"
    }
}
