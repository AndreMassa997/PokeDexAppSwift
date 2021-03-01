//
//  LoaderCollectionViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 26/02/21.
//

import UIKit
import QuartzCore

final class LoaderCollectionReusableView: UICollectionReusableView{
    static let reusableId = "LoaderCollectionReusableView"
   
    var isSpinning = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pokeball"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: PUBLIC METHODS
    func configLoader(){
        self.addSubview(imageView)
        self.setupLayout()
        self.startAnimate()
    }
    
    func stopAnimate() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    //MARK: PRIVATE METHODS
    private func startSpinWithOptions(_ animationOptions: AnimationOptions){
        UIView.animate(withDuration: 0.5, delay: 0, options: animationOptions, animations: { [weak self] in
            guard let self = self else { return }
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }, completion: { [weak self] finished in
            guard let self = self else { return }
            if finished{
                if self.isSpinning{
                    self.startSpinWithOptions(.curveLinear)
                }else if animationOptions != .curveEaseOut{
                    self.startSpinWithOptions(.curveEaseOut)
                }
            }
        })
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    
    private func startAnimate() {
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
    
    
    deinit {
        print("deinit loader")
    }
}

final class LoaderTableViewCell: UITableViewCell{
    static let reusableId = "LoaderTableViewCell"
    private let loader = LoaderCollectionReusableView()
    
    //MARK: PUBLIC METHODS
    func configLoader(){
        self.contentView.addSubview(loader)
        self.setupLayout()
        self.loader.configLoader()
    }
    
    //MARK: PRIVATE METHODS
    private func setupLayout(){
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.topAnchor.constraint(equalTo: contentView.topAnchor),
            loader.heightAnchor.constraint(equalToConstant: 40),
            loader.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            loader.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
