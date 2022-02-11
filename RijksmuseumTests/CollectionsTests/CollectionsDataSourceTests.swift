//
//  CollectionsDataSourceTests.swift
//  RijksmuseumTests
//
//  Created by Kadircan Türker on 3.07.2021.
//

import XCTest
@testable import Rijksmuseum

class CollectionsDataSourceTests: XCTestCase {
    
    var sut: CollectionsDataSource!
    var tableView: UITableView!
    var mockCollections: [FetchCollections.ArtObject]!

    override func setUp() {
        super.setUp()
        mockCollections = [FetchCollections.ArtObject(objectNumber: "", title: "test", webImage: WebImage(url: ""), headerImage: FetchCollections.HeaderImage(url: ""))]
        tableView = UITableView()
        sut = CollectionsDataSource()
    }
    
    override func tearDown() {
        tableView = nil
        mockCollections = nil
        sut = nil
        super.tearDown()
    }
    
    func test_ShouldRegisterCollectionsTableViewCell() {
        // Given
        sut.collections = mockCollections
        sut.registerCells(to: tableView)
        let indexPath = IndexPath(item: 0, section: 0)

        // When
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)

        //Then
        XCTAssertTrue(cell is CollectionsTableViewCell)
    }
    
    func test_ShouldConfigureCell() {
        // Given
        sut.collections = mockCollections
        sut.registerCells(to: tableView)

        // When
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CollectionsTableViewCell
        
        //Then
        XCTAssertEqual(cell?.title.text, mockCollections.first!.title)
    }
    
    func test_NumberOfRowsShouldBeEqualToCollectionsCount() {
        //Given
        sut.collections = mockCollections

        // When
        let numberOfRowsInSection = sut.tableView(tableView, numberOfRowsInSection: 0)

        //Then
        XCTAssertEqual(numberOfRowsInSection, sut.collections.count)
    }

}
