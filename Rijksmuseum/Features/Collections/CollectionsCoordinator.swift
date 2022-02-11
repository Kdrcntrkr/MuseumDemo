//
//  CollectionsCoordinator.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import UIKit
class CollectionsCoordinator: Coordinator {
    var navigationController: UINavigationController
    func start() {
        startCollectionsViewController()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}


private extension CollectionsCoordinator {
    func startCollectionsViewController() {
        let viewModel = CollectionsViewModel(networkController: NetworkManager(),
                                             dataSource: CollectionsDataSource())
        let viewController = CollectionViewController(viewModel: viewModel)
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension CollectionsCoordinator: CollectionViewControllerDelegate {
    func collectionViewControllerDidTapCollection(_ collectionViewController: CollectionViewController, with objectNumber: String) {
        let viewModel = CollectionDetailsViewModel(networkController: NetworkManager())
        let viewController = CollectionDetailsViewController(viewModel: viewModel, objectNumber: objectNumber)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func collectionViewControllerDidGetError(_ collectionViewController: CollectionViewController, with error: NetworkError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.navigationController.present(alert, animated: true, completion: nil)
    }
}


