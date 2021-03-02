//
//  TypeCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

final class TypeCollectionViewCell: UICollectionViewCell{
    static let reusableId = "TypeCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: PUBLIC METHODS
    func configureCell(type: PokemonType){
        self.contentView.backgroundColor = type.mainColor
        self.nameLabel.text = type.rawValue.uppercased()
        self.image.image = type.getImage()
        
        self.addSubviews()
        self.setupLayout(color: type.mainColor)
    }
    
    //MARK: PRIVATE METHODS
    private func addSubviews(){
        self.contentView.addSubview(image)
        self.contentView.addSubview(nameLabel)
    }
    
    private func setupLayout(color: UIColor){
        NSLayoutConstraint.activate([
            //image constraints
            self.image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 15),
            self.image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            self.image.widthAnchor.constraint(equalToConstant: 15),
            
            //label constraints
            self.nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 16),
            self.nameLabel.leftAnchor.constraint(equalTo: self.image.rightAnchor, constant: 5),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        ])
        
        //setup corner radius and shadow of the chip
        contentView.layer.cornerRadius = self.contentView.frame.height/2
        contentView.layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        contentView.clipsToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size), cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
}
