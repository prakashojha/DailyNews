//
//  DailyNewsNetworkTest.swift
//  DailyNewsTests
//
//  Created by bindu on 25/10/21.
//

import XCTest
@testable import DailyNews

class DailyNewsNetworkTest: XCTestCase {

    func test_createLink_with_validString(){
    
        let url = "https://api.newscatcherapi.com/v2/latest_headlines?countries=au&page=1"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue(DNNetworkModel.API_KEY, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "GET"
        
        let expectedURLRequest = NetworkManager.shared.CreateURLRequest(urlString: url)
        
        XCTAssertEqual(urlRequest, expectedURLRequest)
        
    }
    
    func test_createLink_with_invalid_method_POST(){
        let url = "https://api.newscatcherapi.com/v2/latest_headlines?countries=au&page=1"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue(DNNetworkModel.API_KEY, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "POST"
        
        let expectedURLRequest = NetworkManager.shared.CreateURLRequest(urlString: url)
        
        XCTAssertNotEqual(urlRequest, expectedURLRequest)
    }
    
    func test_createLink_with_invalid_API_KEY(){
        let apiKey = DNNetworkModel.API_KEY + "abcd"
        let url = "https://api.newscatcherapi.com/v2/latest_headlines?countries=au&page=1"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "GET"
        
        let expectedURLRequest = NetworkManager.shared.CreateURLRequest(urlString: url)
        
        XCTAssertNotEqual(urlRequest, expectedURLRequest)
    }
    
    
    func test_fetch_image_with_nil_link(){
        let dummyImageData: Data? = nil
        NetworkManager.shared.fetchImage(imageURL: "") { (imageData) in
            XCTAssertEqual(dummyImageData, imageData)
        }
    }
    
    func test_fetch_image_with_valid_link(){
        let urlString = "https://ibb.co/qd2PsSn"
        let imageData = UIImage(named: "dummy")?.pngData()
        NetworkManager.shared.fetchImage(imageURL: urlString) { (data) in
            XCTAssertEqual(imageData, data)
        }
    }
    
    
    func test_fetchNews_with_emptyString(){
        let urlString: String? = nil
        NetworkManager.shared.fetchNews(page: 1, urlString: urlString) { (result) in
            switch(result){
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.InvalidURL)
            default:
                ()
            }
        }
    }
    
    func test_fetchNews_for_Data(){
        //This should be mocked but currently testing for data being populated
        let urlString = "https://api.newscatcherapi.com/v2/latest_headlines?countries=au"
        NetworkManager.shared.fetchNews(page: 1, urlString: urlString) { (result) in
            switch(result){
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            default:
                ()
            }
        }
    }
    
    func test_fetchNews_for_Data_Not_Found_with_invalidPage(){
        let urlString = "https://api.newscatcherapi.com/v2/latest_headlines?countries=au"
        NetworkManager.shared.fetchNews(page: -1, urlString: urlString) { (result) in
            switch(result){
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.DataNotFound)
            default:
                ()
            }
        }
    }
}
