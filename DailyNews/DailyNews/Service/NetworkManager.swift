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

final class NetworkManager{
    let cachedImage = NSCache<NSString, NSData>()
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func CreateURLRequest(urlString: String)->URLRequest?{
        var urlRequest: URLRequest?
        
        if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
            urlRequest?.addValue(DNNetworkModel.API_KEY, forHTTPHeaderField: "x-api-key")
            urlRequest?.httpMethod = "GET"
        }
        return urlRequest
    }
    
    func fetchNews(page: Int, urlString: String?, completion: @escaping (Result<[News], Error>)->Void){
        guard let urlString = urlString else{
            completion(.failure(NetworkError.InvalidURL))
            return
        }
        
        guard let urlRequest = CreateURLRequest(urlString: urlString) else {
            completion(.failure(NetworkError.URLNotFormed))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            let news = try? JSONDecoder().decode(DNNewsModel.self, from: data)
            if let news = news{
                completion(.success(news.articles))
            }
            else{
                completion(.failure(NetworkError.DataNotFound))
            }
        }.resume()
        
    }
    
    func fetchImage(imageURL: String, completion: @escaping (Data?)->Void){
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        
        if let image = cachedImage.object(forKey: NSString(string: imageURL)){
            completion(image as Data)
        }
        else{
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil, let data = data else {
                    completion(nil)
                    return
                }
                self.cachedImage.setObject(data as NSData, forKey: NSString(string: imageURL))
                completion(data)
                
            }.resume()
            
        }
        
    }
    
}
