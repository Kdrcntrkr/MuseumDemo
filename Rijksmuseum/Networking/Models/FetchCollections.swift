//
//  FetchCollections.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import Foundation

enum FetchCollections {
    struct Request: Encodable {
        internal let key: String
        internal let query: String
        internal let pageNumber: Int
    }
    
    struct Response: Codable {
        let artObjects: [ArtObject]
    }
    
    struct ArtObject: Codable {
        let objectNumber: String
        let title: String
        let webImage: WebImage
        let headerImage: HeaderImage
    }

    struct HeaderImage: Codable {
        let url: String
    }
}

struct WebImage: Codable {
    let url: String
}
