//
//  DNTableViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation

class DNTableViewModel{
    
    var model: DNTableModel!
    
    init(model: DNTableModel){
        self.model = model
    }
    
    var tableData: [DNCellViewModel] {
        set(newValue){
            model.cellViewModel.append(contentsOf: newValue)
        }
        get{
            return model.cellViewModel
        }
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
    
    func fetchNewsData(completion: @escaping ()->Void){
        NetworkManager.shared.fetchNews(page: page, urlString: urlString) { [unowned self](result) in
            switch(result){
            case .success(let newsData):
                let data = newsData.map(DNCellViewModel.init)
                DispatchQueue.main.async{
                    self.tableData = data
                    completion()
                }
            case .failure( _):
                completion()
            }
        }
    }
}
