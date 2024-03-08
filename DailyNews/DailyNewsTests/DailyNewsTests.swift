//
//  DailyNewsTests.swift
//  DailyNewsTests
//
//  Created by bindu on 24/10/21.
//

import XCTest
@testable import DailyNews

class DailyNewsTests: XCTestCase {

    var article: News!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        article = News(author: "Bindu",
                              title: "Lecturer",
                              description: "Teaching at MDS",
                              url: "www.yahoo.com",
                              urlToImage: nil,
                              publishedAt: "2021-12-11")
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        article = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        /*self.measure {
            // Put the code you want to measure the time of here.
        }*/
    }
    
//    func test_Article(){
//        let cellViewModel = DNCellViewModel(article: article)
//        
//        XCTAssertEqual(article.author, cellViewModel.author)
//        XCTAssertEqual(article.title, cellViewModel.title)
//        XCTAssertEqual(article.description, cellViewModel.description)
//        XCTAssertEqual(article.url, cellViewModel.url)
//        XCTAssertEqual(article.urlToImage, cellViewModel.urlToImage)
//        XCTAssertEqual(article.publishedAt, cellViewModel.publishedAt)
//    }
//    

}
