//
//  DetailsHeaderView.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

class DetailsHeaderView: UITableViewHeaderFooterView{
    static let reuseId = "DetailsHeaderView"
    private var detailsHeaderViewModel: DetailsHeaderViewModel?
    
    private let imageCarouselView = CarouselView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typesCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.itemSize = CGSize(width: 120, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: TypeCollectionViewCell.reusableId)
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    func configureHeader(detailHeaderViewModel: DetailsHeaderViewModel){
        self.detailsHeaderViewModel = detailHeaderViewModel
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        
        self.imageCarouselView.configureCarousel(carouselViewModel: detailHeaderViewModel.carouselViewModel)
        self.nameLabel.text = detailHeaderViewModel.getPokemonName().capitalized
        typesCollectionView.delegate = self
        typesCollectionView.dataSource = self
        typesCollectionView.layoutIfNeeded()
        
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews(){
        self.contentView.addSubview(imageCarouselView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(typesCollectionView)
    }
    
    private func setupLayout(){
        imageCarouselView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCarouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCarouselView.heightAnchor.constraint(equalToConstant: 250),
            imageCarouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageCarouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageCarouselView.bottomAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            typesCollectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            typesCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            typesCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}

extension DetailsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.detailsHeaderViewModel?.getTypes()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.reusableId, for: indexPath) as? TypeCollectionViewCell, let pokemonType = self.detailsHeaderViewModel?.getTypes()?[indexPath.item].name{
            cell.configureCell(type: pokemonType)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets{
        let itemWidthWithEdge: CGFloat = 125
        let leftRightInsets = UIScreen.main.bounds.width.truncatingRemainder(dividingBy: itemWidthWithEdge * CGFloat(collectionView.numberOfItems(inSection: section))) / 2
        return UIEdgeInsets(top: 0, left: leftRightInsets, bottom: 0, right: leftRightInsets)
    }
    
}
