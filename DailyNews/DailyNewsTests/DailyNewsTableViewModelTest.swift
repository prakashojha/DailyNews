//
//  DailyNewsTableViewModelTest.swift
//  DailyNewsTests
//
//  Created by bindu on 25/10/21.
//

import XCTest
@testable import DailyNews

class DailyNewsTableViewModelTest: XCTestCase {

    func test_fetch_news_data(){
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        
        tableViewModel.fetchNewsData { (status)in
            XCTAssertTrue(status)
        }
    }
    
    func test_fetch_news_invalid_data(){
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        tableViewModel.page = -1
        
        tableViewModel.fetchNewsData {(status) in
            XCTAssertFalse(status)
        }
    }
    

    func test_load_webpage_with_url(){
        let urlString = "www.google.com"
        let url = URL(string: urlString)!
        
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        
        XCTAssertEqual(tableViewModel.loadWebPage(url: url), "OK")
    }
    
    func test_load_webpage_with_empty_url(){
        let urlString = ""
        let url = URL(string: urlString)
        
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        
        XCTAssertEqual(tableViewModel.loadWebPage(url: url), "INVALID URL")
    }
    
    func test_page_setter(){
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        
        tableViewModel.page = 2
        
        XCTAssertEqual(tableViewModel.page, 2)
    }
    
    func test_cell_identifier_getter(){
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        
        XCTAssertEqual(tableViewModel.cellIndetifier, "NewsCell")
    }
    
    func test_isPaginating_getter(){
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        tableViewModel.isPaginating = false
        
        XCTAssertEqual(tableViewModel.isPaginating, false)
    }
    
    func test_removeDuplicates(){
        let articles = [
            DNCellViewModel(article: News(author: "bindu", title: "Testing saves the world", description: "Nothing", url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "bindu", title: "World is enough", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "prakash", title: "No-Test", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "ojha", title: "test", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "ojha", title: "Testing saves the world", description: nil, url: nil, urlToImage: nil, publishedAt: nil)),
            DNCellViewModel(article:News(author: "Bindu", title: "world is enough", description: nil, url: nil, urlToImage: nil, publishedAt: nil))
        ]
        
        
        let tableModel = DNTableModel()
        let tableViewModel = DNTableViewModel(model: tableModel)
        tableViewModel.tableData = articles
        
        tableViewModel.removeDuplicates()
        XCTAssertEqual(tableViewModel.tableData.count, 4)
        
    }
    

}
