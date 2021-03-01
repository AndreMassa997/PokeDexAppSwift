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
    
    private let dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.reusableId)
        tableView.register(LoaderTableViewCell.self, forCellReuseIdentifier: LoaderTableViewCell.reusableId)
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
        
        //get the pokemon species and evolution chain of the pokemon
        detailsViewModel.getPokemonSpeciesAndEvolutionChain(onSuccess: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    //MARK: -PRIVATE METHODS
    @objc private func onDismissTap(sender: UIButton!){
        self.dismiss(animated: true, completion: nil)
        detailsViewModel?.onDismissTapped()
    }
    
    private func setupHeaderView(){
        if let headerViewModel = detailsViewModel?.headerViewModel{
            self.detailsHeaderView.configureHeader(detailHeaderViewModel: headerViewModel)
            self.detailsHeaderView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: detailsHeaderView.getHeaderHeight())
            self.tableView.tableHeaderView = self.detailsHeaderView
        }
    }
    
    private func addSubviews(){
        self.view.addSubview(tableView)
        self.view.addSubview(dismissButton)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            
            
            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    deinit {
        print("deinitialized DetailsViewController")
    }
}

//MARK: -TABLE VIEW DELEGATE, DATA SOURCE
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        self.detailsViewModel?.sectionViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = self.detailsViewModel?.sectionViewModels[section]{
            switch section {
            case .descriptions(let items), .evolutions(let items):
                if let items = items{
                    return items.count
                }else{
                    return 1
                }
            case .stats(let items):
                return items.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.detailsViewModel?.sectionViewModels[indexPath]{
            switch item {
            case .description(let description):
                
                break
            case .stat(let statViewModel):
                if let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reusableId) as? StatsTableViewCell{
                    cell.configureStatCell(statViewModel: statViewModel)
                    return cell
                }
            case .evolution(let evolutionViewModel):
                return UITableViewCell()
            }
        }else{
            //if no items are in section show loader
            if let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.reusableId) as? LoaderTableViewCell{
                cell.configLoader()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
