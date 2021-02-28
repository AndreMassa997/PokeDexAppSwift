//
//  CarouselView.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

final class CarouselView: UIView{
    
    private weak var carouselViewModel: CarouselViewModel?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 200, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CarouselImageCollectionViewCell.self, forCellWithReuseIdentifier: CarouselImageCollectionViewCell.reuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    func configureCarousel(carouselViewModel: CarouselViewModel){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.carouselViewModel = carouselViewModel
        pageControl.numberOfPages = carouselViewModel.getUrls().count
        pageControl.pageIndicatorTintColor = carouselViewModel.getMainColor()
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews(){
        self.addSubview(collectionView)
        self.addSubview(pageControl)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            //collectionView
            collectionView.widthAnchor.constraint(equalToConstant: 200),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            //page control
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            pageControl.leftAnchor.constraint(equalTo: self.leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: self.rightAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension CarouselView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carouselViewModel?.getUrls().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselImageCollectionViewCell.reuseId, for: indexPath) as? CarouselImageCollectionViewCell, let url = carouselViewModel?.getUrls()[indexPath.item]{
            cell.config(url: url)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
}

final class CarouselImageCollectionViewCell: UICollectionViewCell{
    static let reuseId = "CarouselImageCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func config(url: URL) {
        imageView.downloadFromUrl(from: url)
        contentView.addSubview(imageView)
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
