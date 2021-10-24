//
//  DNCellView.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

final class DNCellView: UITableViewCell{
    
    
    private lazy var cellTitle: UILabel = {
        let headLine = UILabel()
        headLine.textAlignment = .left
        headLine.numberOfLines = 2
        headLine.font = UIFont.boldSystemFont(ofSize: 17)
        headLine.sizeToFit()
        headLine.text = " Headline"
        return headLine
    }()
    
    private lazy var cellDescription: UILabel = {
        let subHeading = UILabel()
        subHeading.textAlignment = .justified
        subHeading.numberOfLines = 0
        subHeading.font = UIFont.systemFont(ofSize: 13)
        subHeading.sizeToFit()
        subHeading.text = "SubHeading"
        return subHeading
    }()
    
    private lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.image = UIImage(named: "dummy")
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
        addSubview(cellImage)
        setupConstraints()
    }
    
    func setupConstraints(){
        setupHeadLineConstraint()
        setupSubHeadLineConstraint()
        setupImageConstraint()
    }
    
    
    func setupHeadLineConstraint(){
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellTitle.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            ]
        )
    }
    
    func setupSubHeadLineConstraint(){
        cellDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellDescription.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 0),
            cellDescription.bottomAnchor.constraint(equalTo: cellImage.topAnchor, constant: 0),
            ]
        )
    }
    
    func setupImageConstraint(){
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: cellDescription.bottomAnchor, constant: 5),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            cellImage.heightAnchor.constraint(equalToConstant: 200)
            ]
        )
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
