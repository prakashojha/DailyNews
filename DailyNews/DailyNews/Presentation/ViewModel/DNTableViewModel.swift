//
//  DNTableViewModel.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import Foundation


class DNTableViewModel{
    
    var model: DNTableModel!
    var coordinator: TableViewCoordinatorDelegate?
    var tableData: [DNCellViewModel] = []
    let apiService: APIServiceProtocol
    
    let cachedImage = NSCache<NSString, NSData>()
    
    init(model: DNTableModel, apiService: APIServiceProtocol){
        self.model = model
        self.apiService = apiService
    }
    
    var cellIdentifier: String{
        return model.cellIdentifier
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
    
    func removeDuplicates() {
        var result = [DNCellViewModel]()
        for value in self.tableData {
            if !(result.contains(where: {$0.title.lowercased() == value.title.lowercased()})){
                result.append(value)
            }
        }
        self.tableData = result
    }
    
    func deleteCachedImages(){
        self.cachedImage.removeAllObjects()
    }
    
    func getImageFromCache(_ forKey: String)->Data? {
        return cachedImage.object(forKey: NSString(string: forKey)) as? Data
    }
    
    func storeImageAtCache(_ forKey: String, _ data: Data) {
        self.cachedImage.setObject(data as NSData, forKey: NSString(string: forKey))
    }
    
    func getImageUrl(_ atRow: Int) -> String? {
        var urlImage: String?
        if atRow >= 0 && atRow < self.tableData.count {
            urlImage = self.tableData[atRow].urlToImage
            
        }
        return urlImage
    }
    
    func prefetchImages(_ forRow: Int) {
        getImage(at: forRow)
    }
    
    
    /// Get image data for a given row. API request is made when imageData is not found in cache
    /// - Parameters:
    ///   - row: cell row index
    ///   - completion: pass imageData to caller
    func getImage(at row: Int, _ completion: ( (Data?)->Void)? = nil ) {
        guard let urlToImage = getImageUrl(row) else {
            completion?(nil)
            return
        }
        if let imageData = getImageFromCache(urlToImage) {
            completion?(imageData)
        }
        else{
            fetchImage(imageURL: urlToImage) { data in
                if let data = data {
                    self.storeImageAtCache(urlToImage, data)
                }
                completion?(data)
            }
        }
    }
    
    func fetchImage(imageURL: String, _ completion: ( (Data?)->Void)? = nil ){
        apiService.fetchImage(urlString: imageURL) { data in
            if let data = data {
                completion?(data)
            }
            else{
                completion?(nil)
            }
        }
    }
    
    func fetchNewsData(completion: @escaping (_ status: Bool)->Void){
        apiService.fetchNews(pageLimit: page) { [weak self] (result: Result<DNNewsModel, Error>) in
            switch(result){
            case .success(let newsData):
                let data = newsData.articles.map(DNCellViewModel.init)
                self?.tableData.append(contentsOf: data)
                self?.removeDuplicates()
                DispatchQueue.main.async{
                    completion(true)
                }
            case .failure( _):
                completion(false)
            }
        }
    }
    
    func loadWebPage(url: URL?){
        guard let url = url else {
            coordinator?.showAlert("Url does not exist")
            return
        }
        coordinator?.loadWebPage(url: url)
    }
}
