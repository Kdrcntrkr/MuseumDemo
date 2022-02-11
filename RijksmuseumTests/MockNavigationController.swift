//
//  MockNavigationController.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import UIKit

class MockNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}
