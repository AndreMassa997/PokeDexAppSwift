//
//  DetailsViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class DetailsViewController: UIViewController {
    private var detailsViewModel: DetailsViewModel?
    
    private let detailsHeaderView: DetailsHeaderView = DetailsHeaderView()
    
    private let viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    public func configureDetailView(with detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupHeaderView()
        self.addSubviews()
        self.setupLayout()
    }
    
    private func setupHeaderView(){
        if let headerViewModel = detailsViewModel?.headerViewModel{
            self.detailsHeaderView.configureHeader(detailHeaderViewModel: headerViewModel)
            self.detailsHeaderView.layoutIfNeeded()
            self.tableView.tableHeaderView = self.detailsHeaderView
        }
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
        
        //make background gradient
        if let mainColor = detailsViewModel?.mainColor, let endColor = detailsViewModel?.endColor{
            let gradient = CAGradientLayer()
            gradient.colors = [mainColor.cgColor, endColor.cgColor]
            gradient.frame = self.view.frame
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            self.view.layer.insertSublayer(gradient, at: 0)
        }
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
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
