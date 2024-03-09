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
    case DecodeError
    case NoResponse
    case Unauthorised
    case UnKnown
}

final class APIService : APIServiceProtocol {
    
    let urlRequest: URLRequestProtocol
    let urlSession: URLSession
    
    init(urlRequest: URLRequestProtocol, urlSession: URLSession = .shared) {
        self.urlRequest = urlRequest
        self.urlSession = urlSession
    }

    func CreateURLRequest(pageLimit: Int = 1)->URLRequest?{
        var urlRequest: URLRequest?
        guard pageLimit > 0 else { return nil }
        if let url = URL(string: self.urlRequest.urlString + "&page=\(pageLimit)") {
            urlRequest = URLRequest(url: url)
            urlRequest?.addValue(self.urlRequest.apiKey, forHTTPHeaderField: "x-api-key")
            urlRequest?.httpMethod = self.urlRequest.httpMethod
        }
        return urlRequest
    }
    
    
    func fetchNews<T>(pageLimit: Int, completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
      
        guard let urlRequest = CreateURLRequest(pageLimit: pageLimit) else {
            completion(.failure(NetworkError.URLNotFormed))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            //check if response is HTTPURLResponse.
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(NetworkError.NoResponse))
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return completion(.failure(NetworkError.DecodeError))
                }
                return completion(.success(decodedResponse))
            case 401:
                return completion(.failure(NetworkError.Unauthorised))
            default:
                return completion(.failure(NetworkError.UnKnown))
            }
            
        }.resume()
        
    }
    
    func fetchImage(urlString imageURL: String, completion: @escaping (Data?)->Void){
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            completion(data)
            
        }.resume()
        
    }
    
}
