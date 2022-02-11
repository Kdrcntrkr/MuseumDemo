//
//  AppCoordinatorTest.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 2.07.2021.
//

import XCTest
@testable import Rijksmuseum

class AppCoordinatorTest: XCTestCase {

    var sut: AppCoordinator!

    override func setUp() {
        super.setUp()
        sut = AppCoordinator(navigationController: UINavigationController())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_ShouldStartCollectionsViewController() {
        // When
        sut.start()
        
        // Then
        XCTAssertTrue(sut.navigationController.children.first is CollectionViewController)
    }
    
}
