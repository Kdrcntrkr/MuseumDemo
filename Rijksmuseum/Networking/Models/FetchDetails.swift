//
//  FetchDetails.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import Foundation

enum FetchDetails {
    struct Request: Encodable {
        internal let key: String
        internal let objectNumber: String
    }
    
    struct Response: Codable {
        let artObject: ArtObject
    }
    
    struct ArtObject: Codable {
        let longTitle: String
        let plaqueDescriptionEnglish: String
        let webImage: WebImage
    }
}
