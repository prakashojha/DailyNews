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
    
    func CreateURLRequest(pageLimit: Int) -> URLRequest? {
        return nil
    }
    
    func fetchNews<T>(pageLimit: Int, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        let news = Article(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "")
        let model = NewsModel(articles: [news])
        
        if pageLimit <= 0 {
            completion(.failure(StubAPIServiceError.FailError))
        }
        else {
            completion(.success(model as! T))
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
