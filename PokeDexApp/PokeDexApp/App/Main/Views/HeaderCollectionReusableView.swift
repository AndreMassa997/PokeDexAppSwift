//
//  SearchCollectionReusableView.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 04/03/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView{
    static let reusableId = "HeaderCollectionReusableView"
    
    let imageLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
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
        self.addSubview(imageLogo)
        self.setupLayout()
        self.searchBar.delegate = self
        self.onSearch = onSearch
        self.onFinishSearch = onFinishSearch
    }
    
    //MARK: PRIVATE METHODS
    private func setupLayout(){
        NSLayoutConstraint.activate([
            imageLogo.topAnchor.constraint(equalTo: topAnchor),
            imageLogo.heightAnchor.constraint(equalToConstant: 100),
            imageLogo.leftAnchor.constraint(equalTo: leftAnchor),
            imageLogo.rightAnchor.constraint(equalTo: rightAnchor),
            
            searchBar.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])
        searchBar.layer.cornerRadius = 25
    }
}

extension HeaderCollectionReusableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.onFinishSearch?()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.onSearch?(searchBar.text ?? "")
    }
}
