//
//  DetailsViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class DetailsViewController: UIViewController {
    private var detailsViewModel: DetailsViewModel?
    
    //MARK: -VIEWS DECLARATION
    private let detailsHeaderView: DetailsHeaderView = DetailsHeaderView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.reusableId)
        return tableView
    }()
    
    //MARK: -PUBLIC METHODS
    public func configureDetailView(with detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupHeaderView()
        self.addSubviews()
        self.setupLayout()
    }
    
    //MARK: -PRIVATE METHODS
    private func setupHeaderView(){
        if let headerViewModel = detailsViewModel?.headerViewModel{
            self.detailsHeaderView.configureHeader(detailHeaderViewModel: headerViewModel)
            self.detailsHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: detailsHeaderView.getHeaderHeight())
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

//MARK: -TABLE VIEW DELEGATE, DATA SOURCE
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.detailsViewModel?.statsViewModels.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reusableId) as? StatsTableViewCell, let statViewModel = self.detailsViewModel?.statsViewModels[indexPath.row]{
                cell.configureStatCell(statsViewModel: statViewModel)
                return cell
            }
        default: break
            
        }
        return UITableViewCell()
    }
}
