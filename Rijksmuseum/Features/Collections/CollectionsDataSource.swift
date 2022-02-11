//
//  CollectionsDataSource.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 1.07.2021.
//

import Foundation
import Kingfisher
import UIKit

class CollectionsDataSource: NSObject, UITableViewDataSource {
    
    var collections: [FetchCollections.ArtObject] = []
    
    var viewModels: [CollectionsTableViewCell.Model] {
        return collections.map { CollectionsTableViewCell.Model(title: $0.title, imageUrl: $0.headerImage.url)}
    }
        
    func registerCells(to tableView: UITableView) {
        let nib = UINib(nibName: "CollectionsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "collectionsCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionsCell", for: indexPath) as! CollectionsTableViewCell
        cell.config(with: viewModels[indexPath.row])
        return cell
    }
}
