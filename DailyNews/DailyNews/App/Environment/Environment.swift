//
//  Environment.swift
//  DailyNews
//
//  Created by Saumya Prakash on 9/03/24.
//

import Foundation

struct Environment {
    
    static let shared = Environment()
    private init(){}
    
    private let apiKey: String = "f476e6ddc16b4e35a1c1d816a8f25b49"
    private let baseUrl = "https://newsapi.org/v2/"
    private let topHeadLine = "top-headlines?language=en&pageSize=10"
    
    private var urlString: String {
        let urlString = "\(baseUrl)\(topHeadLine)"
        return urlString
    }
    
    var apiClient: URLRequestProtocol {
        return ApiClient(urlString: urlString, apiKey: apiKey, httpMethod: "GET")
    }
    
}
