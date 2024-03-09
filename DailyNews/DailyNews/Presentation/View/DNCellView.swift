//
//  DNCellView.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

final class DNCellView: UITableViewCell{
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()

    var imageLoaded: Bool = false {
        didSet {
            if imageData == nil {
                DispatchQueue.main.async {
                    self.cellImage.addSubview(self.activityIndicatorView)
                    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.cellImage.centerXAnchor, constant: 0.0),
                        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.cellImage.centerYAnchor, constant: 0.0)
                    ])
                    self.activityIndicatorView.startAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                }
            }
        }
    }
    
    var cellViewModel:DNCellViewModel?{
        didSet{
            if let cellData = cellViewModel{
                cellTitle.text = cellData.title
                cellDescription.text = cellData.description
            }
        }
    }
        
    var imageData: Data? {
        didSet{
            if let imageData = imageData{
                self.imageLoaded = true
                DispatchQueue.main.async {
                    self.cellImage.image = UIImage(data: imageData)
                }
            }
        }
    }
        
    private lazy var cellTitle: UILabel = {
        let headLine = UILabel()
        headLine.textAlignment = .left
        headLine.numberOfLines = 2
        headLine.font = UIFont.boldSystemFont(ofSize: 17)
        headLine.sizeToFit()
        return headLine
    }()
    
    private lazy var cellDescription: UILabel = {
        let subHeading = UILabel()
        subHeading.textAlignment = .justified
        subHeading.numberOfLines = 0
        subHeading.font = UIFont.systemFont(ofSize: 13)
        subHeading.sizeToFit()
        return subHeading
    }()
    
    private lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    
    func setupView(){
        addSubview(cellTitle)
        addSubview(cellDescription)
       // addSubview(activityIndicatorView)
        addSubview(cellImage)
        setupConstraints()
    }
    
    func setupConstraints(){
        setupHeadLineConstraint()
        setupSubHeadLineConstraint()
       // setUpActivityIndicatorConstraint()
        setupImageConstraint()
    }
    
    
    func setupHeadLineConstraint(){
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cellTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cellTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellTitle.bottomAnchor.constraint(lessThanOrEqualTo: cellDescription.topAnchor)
            ]
        )
    }
    
    func setupSubHeadLineConstraint(){
        cellDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cellDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cellDescription.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 0)
            ]
        )
    }
    
//    func setUpActivityIndicatorConstraint() {
//        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//            activityIndicatorView.topAnchor.constraint(equalTo: cellDescription.bottomAnchor, constant: 5),
//            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
//            activityIndicatorView.heightAnchor.constraint(equalToConstant: 200)
//            ]
//        )
//    }
    
    func setupImageConstraint(){
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cellImage.topAnchor.constraint(equalTo: cellDescription.bottomAnchor, constant: 5),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            cellImage.heightAnchor.constraint(equalToConstant: 200)
            ]
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
