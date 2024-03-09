//
//  MockAPIService.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 8/03/24.
//

import Foundation
import UIKit

class MockURLProtocol: URLProtocol{
    
    static var data: Data?
    static var failedError: Error?
    static var response: URLResponse?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let _ = request.url {
            
            // We have a mock response specified so return it.
            if let responseStrong = MockURLProtocol.response {
                self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
            }
            
            // We have mocked data specified so return it.
            if let dataStrong = MockURLProtocol.data {
                self.client?.urlProtocol(self, didLoad: dataStrong)
            }
            
            // We have a mocked error so return it.
            if let errorStrong = MockURLProtocol.failedError {
                self.client?.urlProtocol(self, didFailWithError: errorStrong)
            }
        }
        
        // Send the signal that we are done returning our mock response
        self.client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {
    }
}
