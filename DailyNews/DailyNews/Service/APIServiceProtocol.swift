//
//  ApiServiceProtocol.swift
//  DailyNews
//
//  Created by Saumya Prakash on 7/03/24.
//

import Foundation

protocol APIServiceProtocol {
    
    func CreateURLRequest(pageLimit: Int)->URLRequest?
    func fetchNews<T:Codable>(pageLimit: Int, completion: @escaping (Result<T, Error>)->Void)
    func fetchImage(urlString: String, completion: @escaping (Data?)->Void)
}
