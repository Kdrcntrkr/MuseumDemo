//
//  CollectionsCoordinatorTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum

class CollectionsCoordinatorTests: XCTestCase {

    var sut: CollectionsCoordinator!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow(frame: .zero)
        let navigationController = MockNavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        sut = CollectionsCoordinator(navigationController: navigationController)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_ShouldStartWithCollectionViewController() {
        // When
        sut.start()
        
        // Then
        XCTAssertTrue(sut.navigationController.children.first is CollectionViewController)
    }
    
    func test_ShouldShowDetailsWhenDidTapCollection() {
        // Given
        
        // When
        sut.start()
        sut.collectionViewControllerDidTapCollection(getCollectionViewController(), with: "")
        
        // Then
        XCTAssertTrue(sut.navigationController.children.last is CollectionDetailsViewController)
    }
    
    func test_ShouldShowAlertViewControllerWhenFetchDataFailedWhileReloading() {
        // Given
        
        // When
        sut.start()
        sut.collectionViewControllerDidGetError(getCollectionViewController(), with: NetworkError.noData)
        
        // Then
        XCTAssertTrue(sut.navigationController.presentedViewController is UIAlertController)
    }
    
    func getCollectionViewController() -> CollectionViewController {
        let viewModel = CollectionsViewModel(networkController: MockNetworkManager(),
                                             dataSource: CollectionsDataSource())
        return CollectionViewController(viewModel: viewModel)
    }

}
