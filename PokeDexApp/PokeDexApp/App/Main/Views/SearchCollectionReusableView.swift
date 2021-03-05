//
//  SearchCollectionReusableView.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 04/03/21.
//

import UIKit

class SearchCollectionReusableView: UICollectionReusableView{
    static let reusableId = "SearchCollectionReusableView"
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search name or id"
        searchBar.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    var onSearch: ((_ text: String)->Void)?
    var onFinishSearch: (()->Void)?
    
    //MARK: PUBLIC METHODS
    func configSearchBar(onSearch: ((_ text: String) -> Void)?, onFinishSearch: (() -> Void)?){
        self.addSubview(searchBar)
        self.setupLayout()
        self.searchBar.delegate = self
        self.onSearch = onSearch
        self.onFinishSearch = onFinishSearch
    }
    
    //MARK: PRIVATE METHODS
    private func setupLayout(){
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])
    }
}

extension SearchCollectionReusableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.onFinishSearch?()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.onSearch?(searchBar.text ?? "")
    }
}
