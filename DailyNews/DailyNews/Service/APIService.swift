//
//  NetworkManager.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

enum NetworkError: Error{
    case DataNotFound
    case InvalidURL
    case URLNotFormed
}

final class APIService : APIServiceProtocol {
   
    func CreateURLRequest(urlString: String)->URLRequest?{
        var urlRequest: URLRequest?
        
        if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
            urlRequest?.addValue(DNNetworkModel.API_KEY, forHTTPHeaderField: "x-api-key")
            urlRequest?.httpMethod = "GET"
        }
        return urlRequest
    }
    
    
    func fetchNews<T>(page: Int, urlString: String, completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
      
        guard let urlRequest = CreateURLRequest(urlString: urlString) else {
            completion(.failure(NetworkError.URLNotFormed))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            let news = try? JSONDecoder().decode(T.self, from: data)
            if let news = news {
                completion(.success(news))
            }
            else{
                completion(.failure(NetworkError.DataNotFound))
            }
        }.resume()
        
    }
    
    func fetchImage(urlString imageURL: String, completion: @escaping (Data?)->Void){
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            completion(data)
            
        }.resume()
        
    }
    
}
