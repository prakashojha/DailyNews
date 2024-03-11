//
//  TableCellViewModelTest.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 11/03/24.
//

import XCTest
@testable import DailyNews

class TableCellViewModelTest: XCTestCase {
    var viewModel: TableCellViewModel!
    
    override func setUpWithError() throws {
        viewModel = TableCellViewModel(article: Article(
            author: "Bob Applseed",
            title: "AI",
            description: "A tech boom",
            url: "www.google.com",
            urlToImage: "http://www.imageurl.com",
            publishedAt: "22-02-2001"))
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_urlToImage_whenHttpUrlProvided_ReturnsHttpsUrl(){
        let httpsUrlString: String? = "https://www.imageurl.com"
        let url = viewModel.urlToImage
        XCTAssertEqual(httpsUrlString, url)
    }
    
}
