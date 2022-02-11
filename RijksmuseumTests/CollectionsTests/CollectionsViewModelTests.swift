//
//  CollectionsViewModelTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum


class CollectionsViewModelTests: XCTestCase {

    var sut: CollectionsViewModel!
    var networkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        sut = CollectionsViewModel(networkController: networkManager, dataSource: CollectionsDataSource())
    }
    
    override func tearDown() {
        networkManager = nil
        sut = nil
        super.tearDown()
    }
    
    func test_ShouldFetchCollectionsSuccessfully() {
        // Given
        let fetchDataExpectation = expectation(description: "Fetch Data")
        var collections: FetchCollections.Response?
        // When
        sut.fetchCollections { response, error in
            collections = response
            fetchDataExpectation.fulfill()
        }
        
        // Then
        wait(for: [fetchDataExpectation], timeout: 1)
        XCTAssertEqual(collections!.artObjects.count, 1)
    }
    
    func test_ShouldReturnDataIfThereIsErrorOnNetwork() {
        // Given
        let fetchDataExpectation = expectation(description: "Error")
        networkManager.status = .error
        var errorMessage: String?
        
        // When
        sut.fetchCollections { collections, error in
            errorMessage = error?.localizedDescription
            fetchDataExpectation.fulfill()
        }
        
        // Then
        wait(for: [fetchDataExpectation], timeout: 1)
        XCTAssertEqual(errorMessage!, NetworkError.somethingWentWrong(nil).localizedDescription)
        XCTAssertEqual(sut.dataSource.collections.count, 0)
    }

    func test_ShouldReturnErrorIfDataIsWrong() {
        // Given
        let fetchErrorExpectation = expectation(description: "Fetch Wrong Data")
        networkManager.status = .success
        networkManager.dataType = .unknown
        var errorMessage: NetworkError?

        // When
        sut.fetchCollections { collections, error in
            errorMessage = error!
            fetchErrorExpectation.fulfill()
        }

        // Then
        wait(for: [fetchErrorExpectation], timeout: 1)
        XCTAssertEqual(sut.dataSource.collections.count, 0)
        XCTAssertEqual(NetworkError.parseError.localizedDescription, errorMessage?.localizedDescription)
    }

}
