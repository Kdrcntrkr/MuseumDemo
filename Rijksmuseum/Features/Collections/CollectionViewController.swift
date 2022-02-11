//
//  CollectionViewController.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 2.07.2021.
//

import UIKit

protocol CollectionViewControllerDelegate: AnyObject {
    func collectionViewControllerDidTapCollection(_ collectionViewController: CollectionViewController, with objectNumber: String)
    func collectionViewControllerDidGetError(_ collectionViewController: CollectionViewController, with error: NetworkError)
}

class CollectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: CollectionsViewModel
    var isLoadingList : Bool = false
    weak var delegate: CollectionViewControllerDelegate?
    
    init(viewModel: CollectionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        viewModel.fetchCollections { [weak self] (collections, error) in
            guard let self = self else { return }
            if error == nil {
                guard let artObjects = collections?.artObjects else { return }
                self.viewModel.dataSource.collections.append(contentsOf: artObjects)
                DispatchQueue.main.async { self.tableView.reloadData() }
            } else {
                guard let error = error else { return }
                self.showError(with: error)
            }
            
        }
    }
}

extension CollectionViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objectNumber = viewModel.getObjectNumber(with: indexPath.row)
        self.delegate?.collectionViewControllerDidTapCollection(self, with: objectNumber)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
                self.isLoadingList = true
                self.viewModel.fetchCollections { [weak self] (collections, error) in
                    guard let self = self else { return }
                    if error == nil {
                        guard let collections = collections else { return }
                        self.viewModel.dataSource.collections.append(contentsOf: collections.artObjects)
                        self.insertRowsToTableView(with: collections.artObjects.count)
                    } else {
                        guard let error = error else { return }
                        self.delegate?.collectionViewControllerDidGetError(self, with: error)
                    }
                    self.isLoadingList = false
                }
            }
        }
}

private extension CollectionViewController {
    func configureTableView() {
        viewModel.dataSource.registerCells(to: tableView)
        tableView.dataSource = viewModel.dataSource
    }
    
    func insertRowsToTableView(with countOfData: Int) {
        let indexPaths = (self.viewModel.dataSource.collections.count - countOfData ..< self.viewModel.dataSource.collections.count)
            .map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
            self.tableView.insertRows(at:indexPaths, with: .none)
        }
    }
    
    func showError(with error: NetworkError) {
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
    }
}
