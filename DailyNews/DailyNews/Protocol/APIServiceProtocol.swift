//
//  ApiServiceProtocol.swift
//  DailyNews
//
//  Created by Saumya Prakash on 7/03/24.
//

import Foundation

protocol APIServiceProtocol {
    
    func CreateURLRequest(urlString: String)->URLRequest?
    func fetchNews<T:Codable>(page: Int, urlString: String, completion: @escaping (Result<T, Error>)->Void)
    func fetchImage(urlString: String, completion: @escaping (Data?)->Void)
}
