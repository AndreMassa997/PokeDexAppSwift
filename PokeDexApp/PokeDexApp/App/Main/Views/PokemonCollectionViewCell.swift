//
//  PokemonCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 26/02/21.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell{
    static let reusableId = "PokemonCollectionViewCell"
    private let imageHeight: CGFloat = 100
    
    private let view: UIView = UIView()
    private let image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        image.layer.shadowRadius = 3
        image.layer.shadowOpacity = 0.2
        image.layer.masksToBounds = false
        image.layer.shouldRasterize = true
        image.layer.rasterizationScale = UIScreen.main.scale
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: PRIVATE METHODS
    //Add subviews to the contentView
    private func addSubviews(){
        self.contentView.addSubview(view)
        self.contentView.addSubview(image)
        self.contentView.addSubview(nameLabel)
    }
    
    //Setup UI and constraints of pokemon cell
    private func setupLayout(){
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //image constraint
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            image.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            image.heightAnchor.constraint(equalToConstant: imageHeight),
            
            //view constraint
            view.topAnchor.constraint(equalTo: image.topAnchor, constant: imageHeight/2),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //label constraints
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupShadowsAndCorners(){
        self.view.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: imageHeight/2), size: view.bounds.size), cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    //MARK: PUBLIC METHODS
    //Pokemon cell configuration
    public func configurePokemonCell(pokemonModel: PokemonViewModel){
        self.setupShadowsAndCorners()
        self.addSubviews()
        self.setupLayout()
        
        self.image.downloadFromUrl(from: pokemonModel.imageURL, contentMode: .scaleAspectFit)
        self.nameLabel.text = pokemonModel.name.capitalized
        self.view.backgroundColor = pokemonModel.type?.mainColor
    }
}
