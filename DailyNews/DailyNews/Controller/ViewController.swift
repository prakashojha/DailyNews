//
//  ViewController.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    var tableViewModel: DNTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    func setupView(){
        setupNavigationView()
        setupTableView()
        setupConstraints()
    }
    
    func fetchData(){
        if let flag = tableView.refreshControl?.isRefreshing , flag == true{
            self.tableViewModel.tableData.removeAll()
            NetworkManager.shared.cachedImage.removeAllObjects()
        }
        tableViewModel.fetchNewsData {[unowned self] (status)in
            if status{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewModel.isPaginating = false
                    self.tableView.tableFooterView = nil
                    tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func setupNavigationView(){
        let bounds = self.navigationController!.navigationBar.bounds
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        lable.text = tableViewModel.headerTitle
        lable.font = UIFont(name: tableViewModel.headerFontName, size: CGFloat(tableViewModel.headerFontSize))
        lable.textAlignment = .center
        self.navigationController?.navigationBar.backgroundColor = .cyan
        self.navigationItem.titleView = lable
    }
    
    func setupTableView(){
        tableView = UITableView()
        view.addSubview(tableView)
    
        tableView.register(DNCellView.self, forCellReuseIdentifier: tableViewModel.cellIndetifier)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(didPullToRefresh),
                                            for: .valueChanged)
    }
    
    @objc func didPullToRefresh(){
        fetchData()
    }
    
    func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func CreateLoadingFooter()->UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.center = footerView.center
        
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if let urlToImage = tableViewModel.tableData[indexPath.row].urlToImage{
                NetworkManager.shared.fetchImage(imageURL: urlToImage) { (_) in
            
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewModel.cellRowHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewModel.cellIndetifier, for: indexPath) as? DNCellView
        cell?.cellViewModel = tableViewModel.tableData[indexPath.row]
        return cell ?? UITableViewCell()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
                if !tableViewModel.isPaginating {
                    tableViewModel.isPaginating = true
                    tableViewModel.page += 1
                    self.tableView.tableFooterView = CreateLoadingFooter()
                    fetchData()
                    
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = tableViewModel.tableData[indexPath.row]
        guard let url = URL(string: news.url) else { return }
        _ = tableViewModel.loadWebPage(url: url)
    }
}
