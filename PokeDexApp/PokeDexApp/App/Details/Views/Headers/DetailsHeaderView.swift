//
//  DetailsHeaderView.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

final class DetailsHeaderView: UITableViewHeaderFooterView{
    static let reuseId = "DetailsHeaderView"
    private var detailsHeaderViewModel: DetailsHeaderViewModel?
    
    //MARK: -VIEWS DECLARATION
    private let imageCarouselView = CarouselView()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameAndIdLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
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
        
        //pokemon name and id strings
        let mutableAttributedString = NSMutableAttributedString(string: detailHeaderViewModel.name.capitalized, attributes: [
            .font: UIFont.systemFont(ofSize: 30, weight: .light)
        ])
        let idString = NSAttributedString(string: "\n#\(detailHeaderViewModel.getPokemonId())", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .thin)
        ])
        mutableAttributedString.append(idString)
        
        self.nameAndIdLabel.attributedText = mutableAttributedString
        
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
        self.viewContainer.addSubview(nameAndIdLabel)
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
            viewContainer.heightAnchor.constraint(equalToConstant: 220),
            viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            nameAndIdLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 80),
            nameAndIdLabel.heightAnchor.constraint(equalToConstant: 70),
            nameAndIdLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            nameAndIdLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            
            typesCollectionView.topAnchor.constraint(equalTo: nameAndIdLabel.bottomAnchor, constant: 10),
            typesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            typesCollectionView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            typesCollectionView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
        ])
        
        self.layoutIfNeeded()
        self.setupCornerRadius()
        self.typesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupCornerRadius(){
        //round only top-left and top-right corners
        let viewWidth: CGFloat = UIScreen.main.bounds.width - (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0) - (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
        let bounds = CGRect(x: 0, y: 0, width: viewWidth, height: self.viewContainer.frame.height)
        self.viewContainer.roundCorners([.topLeft, .topRight], bounds: bounds, radius: 40)
    }
}

//MARK: -COLLECTION VIEW DELEGATE, DATASOURCE, LAYOUT
//types chips collection view
extension DetailsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.detailsHeaderViewModel?.types?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.reusableId, for: indexPath) as? TypeCollectionViewCell, let pokemonType = self.detailsHeaderViewModel?.types?[indexPath.item].name else { return UICollectionViewCell() }
        cell.configureCell(type: pokemonType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets{
        let totalCellWidth: CGFloat = 110 * CGFloat(collectionView.numberOfItems(inSection: section))
        let totalSpacingWidth = 10 * CGFloat(collectionView.numberOfItems(inSection: section) - 1)
        let leftRightInsets = (collectionView.safeAreaLayoutGuide.layoutFrame.width - (totalCellWidth + totalSpacingWidth))/2
        return UIEdgeInsets(top: 10, left: leftRightInsets, bottom: 10, right: leftRightInsets)
    }
}
