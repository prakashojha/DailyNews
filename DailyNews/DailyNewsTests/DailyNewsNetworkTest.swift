//
//  DailyNewsNetworkTest.swift
//  DailyNewsTests
//
//  Created by bindu on 25/10/21.
//

import XCTest
@testable import DailyNews

struct StubUrlRequestProtocol: URLRequestProtocol {
    var urlString: String = "www.somerandomstring.com"
    var apiKey: String = "NotNecessary"
    var httpMethod: String = "NONE"
    
}

class DailyNewsNetworkTest: XCTestCase {
    
    var config: URLSessionConfiguration!
        var urlSession: URLSession!
        let urlString = "https://urlRequestedMock.co.nz"
        var expectation: XCTestExpectation!
        var sut: APIService!
        
        /// initialise with initial values.
        override func setUpWithError() throws {
            config = URLSessionConfiguration.ephemeral
            config.protocolClasses = [MockURLProtocol.self]
            urlSession = URLSession(configuration: config)
            //expectation = self.expectation(description: "RemoteNetworkServiceTestExpectation")
//            sut = APIService(urlRequest: StubUrlRequestProtocol(), urlSession: urlSession)
        }
        
        override func tearDownWithError() throws {
            config = nil
            urlSession = nil
            sut = nil
        }
    
    private func getJSONData(from resource: String)->Data?{
        var data: Data?
        if let file = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json") {
            data = try! Data(contentsOf: file)
        }
        return data
    }

    func test_CreateURLRequest_WhenGivenValidInput_CreateValidUrl(){
        var expectedUrlRequest: URLRequest? = nil
        sut = APIService(urlRequest: StubUrlRequestProtocol(), urlSession: urlSession)
        expectedUrlRequest = sut.CreateURLRequest(pageLimit: 5)
        XCTAssertNotNil(expectedUrlRequest)
        
    }
    
    func test_createURLRequest_WhenGivenNegativePageNumber_CreateURLRequestNil(){
        var expectedUrlRequest: URLRequest? = URLRequest(url: URL(string: "https://www.google.com")!)
        let urlRequestProtocol = StubUrlRequestProtocol()
        
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        expectedUrlRequest = sut.CreateURLRequest(pageLimit: -1)
        XCTAssertNil(expectedUrlRequest)
    }
    
    func test_fetchImage_whenGivenEmptyUrlLink_ReturnDataNil() {
        var expectedData: Data? = Data()
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        expectation = self.expectation(description: "RemoteNetworkServiceTestExpectation")
        sut.fetchImage(urlString: "") { data in
            expectedData = data
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertNil(expectedData)
    }
    
    func test_fetchImage_whenErrorOccurs_ReturnDataNil() {
        var expectedData: Data? = Data()
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        self.expectation = expectation(description: "RemoteNetworkServiceTestExpectation")
        
        let failedError: Error? = NetworkError.UnKnown
        MockURLProtocol.failedError = failedError
        
        sut.fetchImage(urlString: "www.google.com") { data in
            expectedData = data
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertNil(expectedData)
    }
    
    func test_fetchImage_whenNoImageDataReceived_ReturnDataNil() {
        var expectedData: Data? = Data()
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        self.expectation = expectation(description: "RemoteNetworkServiceTestExpectation")
        
        let failedError: Error? = NetworkError.DataNotFound
        MockURLProtocol.failedError = failedError
        sut.fetchImage(urlString: "www.google.com") { data in
            expectedData = data
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertNil(expectedData)
    }
    
    func test_fetchNews_whenGivenWrongModel_GetDecodeError() {
        struct Model: Codable {
            var firstItem: String
            var secondItem: String
        }
       
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        self.expectation = expectation(description: "RemoteNetworkServiceTestExpectation")
        
        let response = HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.response = response
        
        sut.fetchNews(pageLimit: 1) { (result: Result<Model, Error>) in
            switch(result){
            
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.DecodeError)
                self.expectation.fulfill()
            default:break
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    func test_fetchNews_whenGivenValidModel_ReturnDataNotNil() {
        struct Model: Codable {
            var firstItem : String
            var secondItem : String
            var quantity: Int
            var price: Double
        }
       
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        self.expectation = expectation(description: "RemoteNetworkServiceTestExpectation")
        
        let response = HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = getJSONData(from: "ResponseModel")
        MockURLProtocol.response = response
        MockURLProtocol.data = data
        
        sut.fetchNews(pageLimit: 1) { (result: Result<Model, Error>) in
            switch(result){
            
            case .success(let data):
                XCTAssertEqual(data.quantity, 5)
                self.expectation.fulfill()
            default:break
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    func test_fetchNews_whenReceivedWrongURLResponse_ReturnError() {
       
       
        let urlRequestProtocol = StubUrlRequestProtocol()
        sut = APIService(urlRequest: urlRequestProtocol, urlSession: urlSession)
        self.expectation = expectation(description: "RemoteNetworkServiceTestExpectation")
        
        let mockUrl = URL(string: urlString)!
        let response: URLResponse? =  URLResponse(url: mockUrl, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        MockURLProtocol.response = response
       
        
        sut.fetchNews(pageLimit: 1) { (result: Result<DNNewsModel, Error>) in
            switch(result){
            
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.NoResponse)
                self.expectation.fulfill()
            default:break
            }
        }
        waitForExpectations(timeout: 3)
    }
    
}
