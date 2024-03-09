//
//  ApiClient.swift
//  DailyNews
//
//  Created by Saumya Prakash on 9/03/24.
//

import Foundation

struct ApiClient: URLRequestProtocol {
    var urlString: String
    var apiKey: String
    var httpMethod: String
    
    init(urlString: String, apiKey: String, httpMethod: String) {
        self.urlString = urlString
        self.apiKey = apiKey
        self.httpMethod = httpMethod
    }
}
