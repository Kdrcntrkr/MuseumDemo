//
//  AppCoordinator.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var collectionsCoordinator: CollectionsCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        collectionsCoordinator = CollectionsCoordinator(navigationController: navigationController)
        collectionsCoordinator?.start()
    }
}
