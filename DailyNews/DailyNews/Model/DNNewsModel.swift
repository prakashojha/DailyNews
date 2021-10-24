//
//  DNNewsModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

struct DNNewsModel: Decodable{
    let articles: [News]
}

struct News: Decodable{
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

extension News {
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "excerpt"
        case url = "link"
        case urlToImage = "media"
        case publishedAt = "published_date"
        
    }
}
