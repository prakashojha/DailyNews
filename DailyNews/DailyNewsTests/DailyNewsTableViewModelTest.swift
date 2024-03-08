//
//  DailyNewsTableViewModelTest.swift
//  DailyNewsTests
//
//  Created by bindu on 25/10/21.
//

import XCTest
@testable import DailyNews



class DailyNewsTableViewModelTest: XCTestCase {
    var stubApiService: StubAPIService!
    var tableModel: DNTableModel!
    var tableViewModel: DNTableViewModel!
    var exp: XCTestExpectation!
    
    override func setUpWithError() throws {
        stubApiService = StubAPIService()
        tableModel = DNTableModel()
        tableViewModel = DNTableViewModel(model: tableModel, apiService: stubApiService)
    }
    
    override func tearDownWithError() throws {
        stubApiService = nil
        tableModel = nil
        exp = nil
        tableViewModel = nil
    }

    func test_WhenFetchDataIsSuccess_ReturnsSuccessStatus(){
        var returnStatus = false
        exp = expectation(description: "DailyNewsTableViewModelTest")
        tableViewModel.fetchNewsData { (status) in
            returnStatus = status
            self.exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertTrue(returnStatus)
    }
    
    
    func test_WhenFetchDataIsNotSuccess_ReturnsFailStatus(){
        var returnStatus = true
        exp = expectation(description: "DailyNewsTableViewModelTest")
        tableViewModel.page = -1
        
        tableViewModel.fetchNewsData {(status) in
            returnStatus = status
            self.exp.fulfill()
           
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertFalse(returnStatus)
        
    }
    
    func test_WhenFetchImageGivenValidImageUrl_ReturnsValidData() {
        var receivedData: Data?
        exp = expectation(description: "DailyNewsTableViewModelTest")
        let imageUrl = "https://googl.com"
        
        tableViewModel.fetchImage(imageURL: imageUrl){ data in
            receivedData = data
            self.exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertNotNil(receivedData)
    }
    
    func test_WhenFetchImageGivenInValidImageUrl_ReturnsDataNil() {
        var receivedData: Data? = Data()
        let imageUrl: String = "This is invalid url"
        exp = expectation(description: "DailyNewsTableViewModelTest")
        tableViewModel.fetchImage(imageURL: imageUrl){ data in
            receivedData = data
            self.exp.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertNil(receivedData)
    }

    func test_WhenGetImageGivenValidRowNumber_ReturnsValidData() {
        var receivedData: Data?
        let urlImage = "https://www.google.com"
        exp = expectation(description: "DailyNewsTableViewModelTest")
        tableViewModel.tableData = [
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: urlImage, publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: ""))
        ]

        tableViewModel.getImage(at: 0) { data in
            receivedData = data
            self.exp.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertNotNil(receivedData)
    }

    func test_GetImageGivenInValidRowNumber_ReturnsDataNil() {
        var receivedData: Data? = Data()
        let urlImage = "https://www.google.com"
        exp = expectation(description: "DailyNewsTableViewModelTest")
        tableViewModel.tableData = [
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: urlImage, publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: ""))
        ]

        tableViewModel.getImage(at: -1) { data in
            receivedData = data
            self.exp.fulfill()
        }

        waitForExpectations(timeout: 3)
        XCTAssertNil(receivedData)
    }
    
    func test_GetImageURLGivenValidRowNumber_ReturnsStringNonOptional() {
        var receivedUrl: String? = nil
        let urlImage: String? = "https://www.google.com"
        tableViewModel.tableData = [
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: urlImage, publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: ""))
        ]
        receivedUrl = tableViewModel.getImageUrl(0)
        XCTAssertEqual(receivedUrl, urlImage)
    }
    
    func test_GetImageURLGivenInValidRowNumber_ReturnsStringOptional() {
        var receivedUrl: String? = "https://www.google.com"
        let urlImage: String? = "https://www.google.com"
        tableViewModel.tableData = [
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: urlImage, publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")),
            DNCellViewModel(article: News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: ""))
        ]
        receivedUrl = tableViewModel.getImageUrl(-1)
        XCTAssertNil(receivedUrl)
    }
    
    func test_StoreImageAtCacheGivenValidUrl_StoreImageDataInCacheSuccess() {
        let urlImage: String = "https://www.google.com"
        let expected = Data([1,2,3,4])
        tableViewModel.storeImageAtCache(urlImage, expected)
        
        let received = tableViewModel.getImageFromCache(urlImage)
        XCTAssertEqual(received, expected)
        
    }
    
    func test_DeleteCachedImages_SuccessWhenDataPresent() {
        let urlImage: String = "https://www.google.com"
        let expected = Data([1,2,3,4])
        tableViewModel.storeImageAtCache(urlImage, expected)
        tableViewModel.deleteCachedImages()
        let received = tableViewModel.getImageFromCache(urlImage)
        XCTAssertNil(received)
    }
    
    func test_WhenDuplicateTitleFound_DuplicateTitleRemoveSuccess(){
        let articles = [
            DNCellViewModel(article:News(author: "bindu", title: "Testing", description: "", url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "bindu", title: "World", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "prakash", title: "No-Test", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "ojha", title: "test", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "ojha", title: "Testing", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "Bindu", title: "world", description: nil, url: nil, urlToImage: nil, publishedAt: nil))
        ]

        tableViewModel.tableData = articles
        tableViewModel.removeDuplicates()
        XCTAssertEqual(tableViewModel.tableData.count, 4)
    }
    
    func test_LoadWebPageWhenGivenValidUrl_LoadPageSuccess(){
        let url = URL(string: "https://www.google.com")!
        let coordinator = SpyCoordinator()
        tableViewModel.coordinator = coordinator
        tableViewModel.loadWebPage(url: url)
        XCTAssertEqual(coordinator.pageLoadCount, 1)
    }
    
    func test_LoadWebPageWhenGivenInValidUrl_LoadPageShowAlert(){
        let url = URL(string: "")
        let coordinator = SpyCoordinator()
        tableViewModel.coordinator = coordinator
        tableViewModel.loadWebPage(url: url)
        XCTAssertEqual(coordinator.alertCount, 1)
    }

}
