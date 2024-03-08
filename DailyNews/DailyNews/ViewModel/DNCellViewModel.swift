//
//  DNCellViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

struct DNCellViewModel{
    
    let article: News
    
    init(article: News) {
        self.article = article
    }
    
    var title: String {
        return article.title ?? "Unknown"
    }
    
    var description: String {
        return article.description ?? "No Content Found"
    }
    
    var url: String {
        return article.url ?? "URL Not Found"
    }

    var urlToImage: String? {
        var https: String?
        if let urlString = article.urlToImage {
            guard let http = URL(string: urlString) else { return nil }
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            https = "\(comps.url!)"
        }
        return https ?? nil
    }

}
