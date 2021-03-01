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
    
    //MARK: -VIEWS DECLARATION
    private let imageCarouselView = CarouselView()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typesCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.itemSize = CGSize(width: 110, height: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: TypeCollectionViewCell.reusableId)
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    //MARK: -PUBLIC METHODS
    func configureHeader(detailHeaderViewModel: DetailsHeaderViewModel){
        self.detailsHeaderViewModel = detailHeaderViewModel
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        
        self.imageCarouselView.configureCarousel(carouselViewModel: detailHeaderViewModel.carouselViewModel)
        self.nameLabel.text = detailHeaderViewModel.getPokemonName().capitalized
        typesCollectionView.delegate = self
        typesCollectionView.dataSource = self
        
        self.addSubviews()
        self.setupLayout()
    }
    
    func getHeaderHeight() -> CGFloat{
        self.viewContainer.frame.origin.y + self.viewContainer.frame.height
    }
    
    //MARK: -PRIVATE METHODS
    private func addSubviews(){
        self.viewContainer.addSubview(nameLabel)
        self.viewContainer.addSubview(typesCollectionView)
        self.contentView.addSubview(viewContainer)
        self.contentView.addSubview(imageCarouselView)
    }
    
    private func setupLayout(){
        imageCarouselView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageCarouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCarouselView.heightAnchor.constraint(equalToConstant: 230),
            imageCarouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageCarouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            viewContainer.topAnchor.constraint(equalTo: imageCarouselView.bottomAnchor, constant: -80),
            viewContainer.heightAnchor.constraint(equalToConstant: 200),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 80),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            
            typesCollectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            typesCollectionView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            typesCollectionView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
        ])
        self.layoutIfNeeded()
    }
}

//MARK: -COLLECTION VIEW DELEGATE, DATASOURCE, LAYOUT
//types chips collection view
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
        let totalCellWidth: CGFloat = 110 * CGFloat(collectionView.numberOfItems(inSection: section))
        let totalSpacingWidth = 10 * CGFloat(collectionView.numberOfItems(inSection: section) - 1)
        let leftRightInsets = (collectionView.bounds.width - (totalCellWidth + totalSpacingWidth))/2
        return UIEdgeInsets(top: 10, left: leftRightInsets, bottom: 10, right: leftRightInsets)
    }
    
}
