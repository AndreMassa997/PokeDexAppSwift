//
//  MovesTableViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 02/03/21.
//

import UIKit

class MovesTableViewCell: UITableViewCell {
    static let reusableId = "MovesTableViewCell"
    
    private var movesViewModel: MovesViewModel?
    
    private let movesCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.itemSize = CGSize(width: 90, height: 30)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MoveCollectionViewCell.self, forCellWithReuseIdentifier: MoveCollectionViewCell.reusableId)
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    //MARK: -PUBLIC METHODS
    func configureCell(movesViewModel: MovesViewModel){
        self.autoresizingMask = .flexibleHeight
        self.contentView.autoresizingMask = .flexibleHeight
        self.movesViewModel = movesViewModel
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        
        movesCollectionView.delegate = self
        movesCollectionView.dataSource = self
                
        self.addSubviews()
        self.setupLayout()
    }
    
    //MARK: -PRIVATE METHODS
    private func addSubviews(){
        self.contentView.addSubview(movesCollectionView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            movesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movesCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            movesCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
        movesCollectionView.layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return movesCollectionView.contentSize
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return movesCollectionView.contentSize
    }
}

extension MovesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movesViewModel?.moves?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoveCollectionViewCell.reusableId, for: indexPath) as? MoveCollectionViewCell, let move = self.movesViewModel?.moves?[indexPath.item]{
            cell.configureCell(name: move.move.name, mainColor: self.movesViewModel?.mainColor ?? .clear)
            return cell
        }
        return UICollectionViewCell()
    }
}
