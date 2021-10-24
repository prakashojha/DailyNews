//
//  ViewController.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        setupNavigationView()
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
}

