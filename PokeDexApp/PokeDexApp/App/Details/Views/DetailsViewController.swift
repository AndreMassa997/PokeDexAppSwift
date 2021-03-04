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
        button.setImage(UIImage(named: "arrow_left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onBackTapped), for: .touchUpInside)
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
        tableView.register(DimensionsTableViewCell.self, forCellReuseIdentifier: DimensionsTableViewCell.reusableId)
        return tableView
    }()
    
    //MARK: -PUBLIC METHODS
    public func configureDetailView(with detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.addSubviews()
        self.setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: -PRIVATE METHODS
    @objc private func changeOrientation(){
        self.setBackgroundGradient()
        self.setupHeaderView()
    }
    
    @objc private func onBackTapped(sender: UIButton!){
        detailsViewModel?.onBackTapped()
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
            dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.setBackgroundGradient()
        self.setupHeaderView()
    }
    
    //makes background gradient
    private func setBackgroundGradient(){
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
            case .dimensions(let items), .stats(let items), .abilities(let items):
                return items.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.detailsViewModel?.sectionViewModels[indexPath]{
            switch item {
            case .dimensions(let dimensionsViewModel):
                if let cell = tableView.dequeueReusableCell(withIdentifier: DimensionsTableViewCell.reusableId) as? DimensionsTableViewCell{
                    cell.configureCell(dimensionsViewModel: dimensionsViewModel)
                    return cell
                }
            case .stat(let statViewModel):
                if let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.reusableId) as? StatsTableViewCell{
                    cell.configureStatCell(statViewModel: statViewModel)
                    return cell
                }
            case .ability(let abilityViewModel):
                let cell = UITableViewCell()
                let label = UILabel(frame: CGRect(x: 40, y: 0, width: tableView.frame.width-80, height: cell.frame.height))
                label.text = abilityViewModel.abilityName.capitalized
                label.textColor = abilityViewModel.mainColor
                label.font = UIFont.systemFont(ofSize: 18, weight: .light)
                cell.addSubview(label)
                let separatorView = UIView(frame: CGRect(x: 30, y: cell.frame.height-1, width: tableView.frame.width-60, height: 1))
                separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                if indexPath.row != (tableView.numberOfRows(inSection: indexPath.section)-1){
                    cell.addSubview(separatorView)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        label.textColor = self.detailsViewModel?.mainColor
        label.textAlignment = .center
        label.text = self.detailsViewModel?.sectionViewModels[section].getSectionName()
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}
