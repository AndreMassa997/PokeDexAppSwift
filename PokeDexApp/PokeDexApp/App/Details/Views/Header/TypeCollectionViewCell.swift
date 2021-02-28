//
//  TypeCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

final class TypeCollectionViewCell: UICollectionViewCell{
    static let reusableId = "TypeCollectionViewCell"
    private final let height: CGFloat = 40
    
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
    
    func configureCell(type: PokemonType){
        self.contentView.backgroundColor = type.color()
        self.nameLabel.text = type.rawValue.uppercased()
        self.image.image = type.getImage()
        
        self.addSubviews()
        self.setupLayout(color: type.color())
    }
    
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
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 15), size: bounds.size), cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
}
