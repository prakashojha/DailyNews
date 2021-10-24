//
//  DNCellViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

struct DNCellViewModel{
    
    let article: News
    
    init(article: News){
        self.article = article
    }
    
    var author: String{
        return article.author ?? "Unknown"
    }
    
    var title: String{
        return article.title ?? "Unknown"
    }
    
    var description: String{
        return article.description ?? "No Content Found"
    }
    
    var url: String{
        return article.url ?? "URL Not Found"
    }
    
    var urlToImage: String?{
        var https: String?
        if let urlString = article.urlToImage{
            let http = URL(string: urlString)!
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            https = "\(comps.url!)"
        }
        
        return https ?? nil
    }

    
    var publishedAt: String{
        return article.publishedAt ?? "Unknown"
    }
}
