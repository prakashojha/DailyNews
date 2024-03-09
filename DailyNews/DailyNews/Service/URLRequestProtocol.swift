//
//  URLRequestProtocol.swift
//  DailyNews
//
//  Created by Saumya Prakash on 9/03/24.
//

import Foundation

protocol URLRequestProtocol {
    var urlString: String { get }
    var apiKey: String { get }
    var httpMethod: String { get }
}
