//
//  StubAPIService.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 8/03/24.
//

import XCTest
@testable import DailyNews

enum StubAPIServiceError: Error {
    case FailError
}

class StubAPIService: APIServiceProtocol {
   
    func CreateURLRequest(urlString: String) -> URLRequest? {
        return nil
    }
    
    func fetchNews<T>(page: Int, urlString: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        let news = News(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")
        let model = DNNewsModel(articles: [news])
        
        if let _ = URL(string: urlString) {
            
            if page <= 0 {
                completion(.failure(StubAPIServiceError.FailError))
            }
            else {
                completion(.success(model as! T))
            }
        }
        else{
            completion(.failure(StubAPIServiceError.FailError))
        }
        
    }
    
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        if let _ = URL(string: urlString) {
            completion(Data())
        }
        else{
            completion(nil)
        }
    }
    
}
