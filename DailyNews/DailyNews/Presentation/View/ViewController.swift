//
//  ViewController.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

class ViewController: UIViewController {

    private var tableView: UITableView!
    private var tableViewModel: TableViewModel
    
    init(tableViewModel: TableViewModel!) {
        self.tableViewModel = tableViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationView()
    }
    
    func setupView(){
        
        setupTableView()
        setupConstraints()
    }
    
    func fetchData(){
        if let flag = tableView.refreshControl?.isRefreshing , flag == true{
            self.tableViewModel.tableData.removeAll()
            tableViewModel.deleteCachedImages()
        }
        tableViewModel.fetchNewsData {[unowned self] (isFetchSuccess)in
            if isFetchSuccess {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewModel.isPaginating = false
                    self.tableView.tableFooterView = nil
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func setupNavigationView(){
      
        let label = UILabel()
        label.text = tableViewModel.headerTitle
        label.font = UIFont(name: tableViewModel.headerFontName, size: CGFloat(tableViewModel.headerFontSize))
        label.textAlignment = .center
        self.navigationItem.titleView = label
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemRed
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    func setupTableView(){
        tableView = UITableView()
        view.addSubview(tableView)
    
        tableView.register(TableCellView.self, forCellReuseIdentifier: tableViewModel.cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
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
        for indexPath in indexPaths {
            tableViewModel.prefetchImages(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewModel.cellRowHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewModel.cellIdentifier, for: indexPath) as? TableCellView
        if indexPath.row >= 0 && indexPath.row < tableViewModel.tableData.count {
            cell?.cellViewModel = tableViewModel.tableData[indexPath.row]
        }
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // time to fetch image if not already
        
        if let cellView = cell as? TableCellView {
            cellView.imageLoaded = false
            tableViewModel.getImage(at: indexPath.row) { data in
                if let data = data {
                    cellView.imageData = data
                }
                else {
                    cellView.imageData = UIImage(named: "dummy")?.pngData()
                }
                cellView.imageLoaded = true
                
            }
        }
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
        let urlString = tableViewModel.tableData[indexPath.row].urlString
        tableViewModel.loadWebPage(urlString: urlString)
        
    }
    
}
