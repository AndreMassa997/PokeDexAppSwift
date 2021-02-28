//
//  DetailsViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class DetailsViewController: UIViewController {
    private var detailsViewModel: DetailsViewModel?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.register(DetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailsHeaderView.reuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    public func configureDetailView(with detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
        self.view.backgroundColor = detailsViewModel.mainColor
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.addSubviews()
        self.setupLayout()
    }
    
    private func addSubviews(){
        self.view.addSubview(tableView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.detailsViewModel?.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewController")
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailsHeaderView.reuseId) as? DetailsHeaderView, let headerViewModel = self.detailsViewModel?.headerViewModel{
            header.configureHeader(detailHeaderViewModel: headerViewModel)
            return header
        }
        return UIView()
    }
}
