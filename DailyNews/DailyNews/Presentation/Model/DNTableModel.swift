//
//  DNTableModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

struct DNTableModel{
    var cellIdentifier: String! = "NewsCell"
    var page = 1
    var cellRowHeight = 300
    var headerTitle = "Daily News"
    var headerFontName = "BodoniSvtyTwoSCITCTT-Book"
    var headerFontSize = 32
    var isPaginating = false
    //var baseUrl = "https://api.newscatcherapi.com/v2/"
    //var AULatestHeadLine = "latest_headlines?countries=au&page_size=20"
    
   // var baseUrl = "https://newsapi.org/v2/top-headlines?language=en&pageSize=10&page=1"
    
//    var urlString: String{
//        let urlString = "\(baseUrl)\(AULatestHeadLine)&page=\(page)"
//        return urlString
//    }    
}

