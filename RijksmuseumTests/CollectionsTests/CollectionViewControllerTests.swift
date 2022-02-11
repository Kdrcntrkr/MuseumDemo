//
//  CollectionViewControllerTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum

class CollectionViewControllerTests: XCTestCase {

    var sut: CollectionViewController!
    var viewModel: MockViewModel!
    var networkManager: MockNetworkManager!
    var dataSource: CollectionsDataSource!
    
    override func setUp() {
        dataSource = CollectionsDataSource()
        networkManager = MockNetworkManager()
        viewModel = MockViewModel(networkController: networkManager, dataSource: dataSource)
        sut = CollectionViewController(viewModel: viewModel)
        
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_ShouldFetchCollectionsWhenViewDidLoad() {
        // When
        _ = sut.view
        
        // Then
        XCTAssertTrue(viewModel.didCallFetchCollections)
    }
    
    func test_ShouldShowErrorIfThereIsErrorWhileFetchingCollections() {
        // Given
        networkManager.status = .error
        viewModel.status = .error
        
        // When
        _ = sut.view
        
        // Then
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
    
    func test_ShouldInformDelegateWhenCollectionTapped() {
        // Given
        let mockDelegate = MockDelegate()

        // When
        _ = sut.view
        sut.delegate = mockDelegate
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        // Then
        XCTAssertTrue(mockDelegate.didTapCollection)
    }
    
    func test_ShouldFetchNewCollectionsWhenScrollToBottom() {
        // Given
        
        // When
        _ = sut.view
        sut.tableView.scrollToRow(at: IndexPath(row: 9, section: 0), at: .bottom, animated: false)
        
        // Then
        XCTAssertEqual(sut.viewModel.dataSource.collections.count, 20)
    }
    
    func test_ShouldInformDelegateWhenFetchingNewDataFromReloadingIsFailed() {
        // Given
        let mockDelegate = MockDelegate()
        
        // When
        _ = sut.view
        sut.delegate = mockDelegate
        viewModel.status = .error
        sut.tableView.scrollToRow(at: IndexPath(row: 9, section: 0), at: .bottom, animated: false)
        
        // Then
        XCTAssertTrue(mockDelegate.didGetError)
    }
    
    class MockViewModel: CollectionsViewModel {
        enum Status { case success, error }
        var status: Status = .success
        private(set) var didCallFetchCollections = false
        override func fetchCollections(handler: @escaping (FetchCollections.Response?, NetworkError?) -> Void) {
            didCallFetchCollections = true
            switch status {
            case .success:
                handler(getCollections(), nil)
            case .error:
                handler(nil, .noData)
            }
        }
        
        func getCollections() -> FetchCollections.Response {
            return FetchCollections.Response(artObjects: [FetchCollections.ArtObject(objectNumber: "", title: "", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: "")),FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: ""))])
        }
    }
        
    class MockDelegate: CollectionViewControllerDelegate {
        private(set) var didTapCollection = false
        private(set) var didGetError = false
        
        func collectionViewControllerDidTapCollection(_ collectionViewController: CollectionViewController, with objectNumber: String) {
            didTapCollection = true
        }
        
        func collectionViewControllerDidGetError(_ collectionViewController: CollectionViewController, with error: NetworkError) {
            didGetError = true
        }
    }
}
