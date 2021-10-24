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
        }
        tableViewModel.fetchNewsData {[unowned self] in
            DispatchQueue.main.async {
                tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.tableViewModel.isPaginating = false
                self.tableView.tableFooterView = nil
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
        tableView.rowHeight = CGFloat(tableViewModel.cellRowHeight)
        tableView.register(DNCellView.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DNCellView
        cell?.cellViewModel = tableViewModel.tableData[indexPath.row]
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = tableViewModel.tableData.count - 1
        if indexPath.row == lastItem && !tableViewModel.isPaginating{
            tableViewModel.isPaginating = true
            tableViewModel.page += 1
            self.tableView.tableFooterView = CreateLoadingFooter()
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = tableViewModel.tableData[indexPath.row]
        guard let url = URL(string: news.url) else { return }
        _ = tableViewModel.loadWebPage(url: url)
    }
}
