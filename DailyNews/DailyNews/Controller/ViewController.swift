//
//  ViewController.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        setupNavigationView()
        setupTableView()
        setupConstraints()
    }
    
    func setupNavigationView(){
        let bounds = self.navigationController!.navigationBar.bounds
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        lable.text = "Daily News"
        lable.font = UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 32)
        lable.textAlignment = .center
        
        self.navigationController?.navigationBar.backgroundColor = .cyan
        self.navigationItem.titleView = lable
    }
    
    func setupTableView(){
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.rowHeight = CGFloat(400)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DNCellView
        return cell ?? UITableViewCell()
        
    }
    
}
