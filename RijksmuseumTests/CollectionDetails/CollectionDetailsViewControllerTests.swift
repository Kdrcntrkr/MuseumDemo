//
//  CollectionDetailsViewControllerTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum

class CollectionDetailsViewControllerTests: XCTestCase {

    var sut: CollectionDetailsViewController!
    var viewModel: MockViewModel!
    var networkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        viewModel = MockViewModel(networkController: networkManager)
        sut = CollectionDetailsViewController(viewModel: viewModel, objectNumber: "")
    }
    
    override func tearDown() {
        sut = nil
        networkManager = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_ShouldCallFetchDetailsOnViewDidLoad() {
        // When
        _ = sut.view
        
        // Then
        XCTAssertTrue(viewModel.didCallFetchDetails)
    }
    
    func test_ShouldBindModelToViewWhenFetchSucceeded() {
        // Given
        let timeInSeconds = 0.5
        let expectation = XCTestExpectation(description: "Delay")
        
        // When
        _ = sut.view
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) { expectation.fulfill() }
        
        // Then
        wait(for: [expectation], timeout: timeInSeconds)
        XCTAssertEqual(sut.titleLabel.text, "title")
        XCTAssertEqual(sut.descriptionLabel.text, "desc")
        
    }
    
    func test_ShouldShowErrorWhenFetchFailed() {
        // Given
        let timeInSeconds = 0.5
        let expectation = XCTestExpectation(description: "Delay")
        networkManager.status = .error
        viewModel.status = .error
        
        // When
        _ = sut.view
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) { expectation.fulfill() }
        
        // Then
        wait(for: [expectation], timeout: timeInSeconds)
        XCTAssertFalse(sut.noDataLabel.isHidden)
    }
    
    class MockViewModel: CollectionDetailsViewModel {
        enum Status { case success, error }
        var status: Status = .success
        private(set) var didCallFetchDetails = false
        override func fetchDetails(with objectNumber: String, handler: @escaping (FetchDetails.Response?, NetworkError?) -> Void) {
            didCallFetchDetails = true
            switch status {
            case .success:
                handler(getDetail(), nil)
            case .error:
                handler(nil, .somethingWentWrong(nil))
            }
        }
        
        func getDetail() -> FetchDetails.Response {
            return FetchDetails.Response(artObject: FetchDetails.ArtObject(longTitle: "title", plaqueDescriptionEnglish: "desc", webImage: WebImage(url: "")))
        }
    }

}
