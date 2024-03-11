//
//  DNCellViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

struct TableCellViewModel{
    
    let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    var title: String? {
        return article.title
    }
    
    var description: String? {
        return article.description
    }
    
    var urlString: String? {
        return article.url
    }

    var urlToImage: String? {
        var httpsUrlString: String?
        if let urlString = article.urlToImage {
            guard let http = URL(string: urlString) else { return nil }
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            httpsUrlString = "\(comps.url!)"
        }
        return httpsUrlString
    }
}
