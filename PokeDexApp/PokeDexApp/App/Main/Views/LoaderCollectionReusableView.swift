//
//  LoaderCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 26/02/21.
//

import UIKit

final class LoaderCollectionReusableView: UICollectionReusableView{
    static let reusableId = "LoaderCollectionReusableView"
       
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pokeball"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: PUBLIC METHODS
    func configLoaderAndSpin(){
        self.addSubview(imageView)
        self.setupLayout()
        self.startAnimate()
    }
    
    func stopAnimate() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
        self.imageView.isHidden = true
    }
    
    //MARK: PRIVATE METHODS
    private func setupLayout(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    private func startAnimate() {
        self.imageView.isHidden = false
        self.rotate()
    }
    
    private func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
