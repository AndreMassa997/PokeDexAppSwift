//
//  MainViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class MainViewController: UIViewController {
    private var mainViewModel: MainViewModel?
    private weak var footerLoaderView: LoaderCollectionReusableView?
    
    private let collectionView: UICollectionView = {
        let itemSize: CGFloat = 150
        let edge: CGFloat = 20
        let inset = UIScreen.main.bounds.width.truncatingRemainder(dividingBy: itemSize + edge/2) / 2
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = edge
        collectionViewFlowLayout.minimumLineSpacing = edge
        collectionViewFlowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: edge, left: inset, bottom: edge, right: inset)
        collectionViewFlowLayout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LoaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoaderCollectionReusableView.reusableId)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reusableId)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.reusableId)
        return collectionView
    }()
        
    //MARK: PUBLIC METHODS
    public func configure(with viewModel: MainViewModel){
        self.view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.mainViewModel = viewModel
        self.addViews()
        self.setupLayout()
        
        //get the first list of pokemons
        mainViewModel?.getPokemons(){ [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: PRIVATE METHODS
    private func addViews(){
        self.view.addSubview(self.collectionView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func showAlert(with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainViewModel?.pokemonCells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.reusableId, for: indexPath) as? PokemonCollectionViewCell, let pokemon = mainViewModel?.pokemonCells[indexPath.item]{
            cell.configurePokemonCell(pokemonModel: pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let mainViewModel = mainViewModel else { return }
        if !mainViewModel.isSearching{
            let initalPokemonsNumber = mainViewModel.pokemonCells.count
            if initalPokemonsNumber > 0, indexPath.item == initalPokemonsNumber - 1{
                mainViewModel.getPokemons(onSuccess: {
                    var indexPaths: [IndexPath] = []
                    let newPokemonsNumber = mainViewModel.pokemonCells.count - initalPokemonsNumber
                    for i in 0..<newPokemonsNumber{
                        indexPaths.append(IndexPath(item: initalPokemonsNumber + i, section: 0))
                    }
                    collectionView.insertItems(at: indexPaths)
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reusableId, for: indexPath) as? HeaderCollectionReusableView{
                header.configSearchBar(
                    onSearch: { [weak self] searchedText in
                        self?.mainViewModel?.searchPokemon(text: searchedText, onSuccess: {
                            self?.collectionView.reloadData()
                        }, onError: { [weak self] in
                            self?.showAlert(with: "Sorry!", message: "Pokemons not found on server or locally")
                        })
                }, onFinishSearch: { [weak self] in
                    self?.mainViewModel?.didFinishSearching()
                    self?.collectionView.reloadData()
                })
                return header
            }
        }else{
            if let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderCollectionReusableView.reusableId, for: indexPath) as? LoaderCollectionReusableView{
                footer.configLoader()
                self.footerLoaderView = footer
                if self.mainViewModel?.isSearching ?? false{
                    footer.stopAnimate()
                }
                return footer
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter{
            self.footerLoaderView?.stopAnimate()
            self.footerLoaderView = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = self.mainViewModel?.pokemonCells[indexPath.item] else { return }
        self.mainViewModel?.didSelectPokemon(pokemon: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 150)
    }
}
