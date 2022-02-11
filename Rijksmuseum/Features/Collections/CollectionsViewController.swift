//
//  CollectionsViewController.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import UIKit

class CollectionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    internal var viewModal: CollectionsViewModal?
    internal var dataSource: CollectionsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModal?.fetchCollections()
        viewModal?.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.dataSource?.collections = self.viewModal?.collections
            self.tableView.reloadData()
        }
    }
}

extension CollectionsViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

private extension CollectionsViewController {
    func configureTableView() {
        dataSource?.registerCells(to: tableView)
        tableView.dataSource = dataSource
    }
}

