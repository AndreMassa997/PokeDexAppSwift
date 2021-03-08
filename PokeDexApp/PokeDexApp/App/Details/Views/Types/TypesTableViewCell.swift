//
//  TypesTableViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 07/03/21.
//

import UIKit

final class TypesTableViewCell: UITableViewCell{
    static let reusableId = "TypesTableViewCell"
    
    private var typesCellViewModel: TypesCellViewModel?
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
        collectionView.allowsSelection = false
        
        //register cell
        collectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: TypeCollectionViewCell.reusableId)
        return collectionView
    }()
    
    //handled layout subviews to avoid UICollectionViewFlowLayoutBreakForInvalidSizes error on rotation
    override func layoutSubviews() {
        super.layoutSubviews()
        typesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func configureCell(typesViewModel: TypesCellViewModel){
        self.typesCellViewModel = typesViewModel
        
        self.contentView.addSubview(typesCollectionView)
        self.contentView.autoresizingMask = .flexibleHeight
        self.autoresizingMask = .flexibleHeight

        typesCollectionView.delegate = self
        typesCollectionView.dataSource = self
        
        self.setupLayout()
    }
    
    //MARK: -PRIVATE METHODS
    private func setupLayout(){
        NSLayoutConstraint.activate([
            typesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            typesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            typesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            typesCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            typesCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}

//MARK: -COLLECTION VIEW DELEGATE, DATASOURCE, LAYOUT
//types chips collection view
extension TypesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.typesCellViewModel?.types.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.reusableId, for: indexPath) as? TypeCollectionViewCell, let pokemonType = self.typesCellViewModel?.types[indexPath.item].name else { return UICollectionViewCell() }
        cell.configureCell(type: pokemonType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets{
        let totalCellWidth: CGFloat = 110 * CGFloat(collectionView.numberOfItems(inSection: section))
        let totalSpacingWidth = 10 * CGFloat(collectionView.numberOfItems(inSection: section) - 1)
        let leftRightInsets = (collectionView.frame.width - (totalCellWidth + totalSpacingWidth))/2
        return UIEdgeInsets(top: 10, left: leftRightInsets, bottom: 10, right: leftRightInsets)
    }
}


