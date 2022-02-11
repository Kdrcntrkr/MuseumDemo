//
//  Coordinator.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 30.06.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
