//
//  MoveCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 02/03/21.
//

import UIKit

class MoveCollectionViewCell: UICollectionViewCell {
    static let reusableId = "MoveCollectionViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //MARK: PUBLIC METHODS
    func configureCell(name: String, mainColor: UIColor){
        self.contentView.backgroundColor = .clear
        self.nameLabel.text = name.uppercased()
        
        self.addSubviews()
        self.setupLayout(color: mainColor)
    }
    
    //MARK: PRIVATE METHODS
    private func addSubviews(){
        self.contentView.addSubview(nameLabel)
    }
    
    private func setupLayout(color: UIColor){
        NSLayoutConstraint.activate([
            //label constraints
            self.nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 16),
            self.nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5)
        ])
        
        self.nameLabel.textColor = color
        
        //setup corner radius and border of the chip
        contentView.layer.cornerRadius = self.contentView.frame.height/2
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = color.cgColor
    }
}
