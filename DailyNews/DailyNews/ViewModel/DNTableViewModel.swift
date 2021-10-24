//
//  DNTableViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

class DNTableViewModel{
    
    var model: DNTableModel!
    var coordinator: TableViewCoordinator?
    var tableData: [DNCellViewModel] = []
    
    init(model: DNTableModel){
        self.model = model
    }
    
    var cellIndetifier: String{
        return model.cellIndetifier
    }
    
    var page: Int{
        set{
            model.page = newValue
        }
        get{
            return model.page
        }
    }
    
    var headerTitle: String{
        return model.headerTitle
    }
    
    var headerFontName: String{
        return model.headerFontName
    }
    
    var headerFontSize: Int{
        return model.headerFontSize
    }
    
    var urlString: String{
        return model.urlString
    }
    
    var cellRowHeight: Int{
        return model.cellRowHeight
    }
    
    var isPaginating: Bool{
        set {
            model.isPaginating = newValue
        }
        get{
            return model.isPaginating
        }
    }
    
    func fetchNewsData(completion: @escaping (_ status: Bool)->Void){
        NetworkManager.shared.fetchNews(page: page, urlString: urlString) { [unowned self](result) in
            switch(result){
            case .success(let newsData):
                let data = newsData.map(DNCellViewModel.init)
                DispatchQueue.main.async{
                    self.tableData = data
                    completion(true)
                }
            case .failure( _):
                completion(false)
            }
        }
    }
    
    func loadWebPage(url: URL?)->String{
        if let url = url{
            coordinator?.loadWebPage(url: url)
        } else {
            return "INVALID URL"
        }
        
        return "OK"
    }
}
