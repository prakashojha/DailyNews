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
        tableViewModel = DNTableViewModel(model: DNTableModel())
        setupView()
        fetchData()
        
    }

    func setupView(){
        setupNavigationView()
        setupTableView()
        setupConstraints()
    }
    
    func fetchData(){
        tableViewModel.fetchNewsData {[unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        tableView.rowHeight = CGFloat(300)
        tableView.register(DNCellView.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
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
    
}
