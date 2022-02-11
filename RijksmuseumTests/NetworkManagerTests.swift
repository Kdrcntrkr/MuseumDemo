//
//  NetworkManagerTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum
 
class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!
    var session: MockURLSession!
    var url: URL!
    var result: Data!
    
    override func setUp() {
        super.setUp()
        url = URL(fileURLWithPath: "url")
        session = MockURLSession()
        sut = NetworkManager(urlSession: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        url = nil
        super.tearDown()
    }
    
    func test_ShouldReturnData() {
        // Given
        let fetchDataExpectation = expectation(description: "Fetch Data")

        let data = Data(bytes: [1], count: 1)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        session.data = data
        session.response = response
        sut = NetworkManager(urlSession: session)
        // When
        let request = FetchDetails.Request(key: "", objectNumber: "")
        sut.sendRequest(request: .fetchDetails(request)) { result in
            if case let .success(data) = result {
                self.result = data
            }
            fetchDataExpectation.fulfill()
        }

        //Then
        wait(for: [fetchDataExpectation], timeout: 1)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, data)
    }
    
    class MockURLSession: URLSession {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            let data = self.data
            let response = self.response
            let error = self.error

            return URLSessionDataTaskMock {
                completionHandler(data, response, error)
            }
        }
    }

    class URLSessionDataTaskMock: URLSessionDataTask {
        private let closure: () -> Void
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }
    }

}
