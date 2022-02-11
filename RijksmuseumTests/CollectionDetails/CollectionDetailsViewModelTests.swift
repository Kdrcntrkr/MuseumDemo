//
//  CollectionDetailsViewModelTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 4.07.2021.
//

import XCTest
@testable import Rijksmuseum

class CollectionDetailsViewModelTests: XCTestCase {
    
    var sut: CollectionDetailsViewModel!
    var networkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        sut = CollectionDetailsViewModel(networkController: networkManager)
    }
    
    override func tearDown() {
        networkManager = nil
        sut = nil
        super.tearDown()
    }
    
    func test_ShouldFetchDetailsSuccessfuly() {
        // Given
        let fetchDataExpectation = expectation(description: "Fetch Data")
        var details: FetchDetails.Response?
        networkManager.dataType = .details
        // When
        sut.fetchDetails(with: "") { response, error in
            details = response
            fetchDataExpectation.fulfill()
        }
        
        // Then
        wait(for: [fetchDataExpectation], timeout: 1)
        XCTAssertNotNil(details!)
    }
    
    func test_ShouldReturnDataIfThereIsErrorOnNetwork() {
        // Given
        let fetchDataExpectation = expectation(description: "Error")
        networkManager.status = .error
        var errorMessage: String?
        
        // When
        sut.fetchDetails(with: "") { details, error in
            errorMessage = error?.localizedDescription
            fetchDataExpectation.fulfill()
        }
        
        // Then
        wait(for: [fetchDataExpectation], timeout: 1)
        XCTAssertEqual(errorMessage!, NetworkError.somethingWentWrong(nil).localizedDescription)
    }

    func test_ShouldReturnErrorIfDataIsWrong() {
        // Given
        let fetchErrorExpectation = expectation(description: "Fetch Wrong Data")
        networkManager.status = .success
        networkManager.dataType = .unknown
        var errorMessage: NetworkError?

        // When
        sut.fetchDetails(with: "") { collections, error in
            errorMessage = error!
            fetchErrorExpectation.fulfill()
        }

        // Then
        wait(for: [fetchErrorExpectation], timeout: 1)
        XCTAssertEqual(NetworkError.parseError.localizedDescription, errorMessage?.localizedDescription)
    }
}
