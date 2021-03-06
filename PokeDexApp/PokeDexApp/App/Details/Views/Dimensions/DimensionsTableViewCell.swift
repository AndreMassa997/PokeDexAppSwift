//
//  DimensionTableViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 03/03/21.
//

import UIKit

final class DimensionsTableViewCell: UITableViewCell{
    static let reusableId = "DimensionTableViewCell"
    
    let weightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weight"
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightProgressBar: UIProgressView = UIProgressView()
    
    let heightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Height"
        return label
    }()
    
    var heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heightProgressBar: UIProgressView = UIProgressView()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        return stackView
    }()
    
    let heightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        return stackView
    }()
    
    
    //MARK: PRIVATE METHODS
    //Add subviews to the contentView and to the stackViews
    private func addSubviews(){
        weightStackView.addArrangedSubview(weightTitleLabel)
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(weightProgressBar)
        heightStackView.addArrangedSubview(heightTitleLabel)
        heightStackView.addArrangedSubview(heightLabel)
        heightStackView.addArrangedSubview(heightProgressBar)
        self.contentView.addSubview(weightStackView)
        self.contentView.addSubview(heightStackView)
        self.contentView.addSubview(separatorView)
    }
    
    //Setup UI and constraints of cell
    private func setupLayout(){
        NSLayoutConstraint.activate([
            
            //line separator view
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 100),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            weightStackView.rightAnchor.constraint(equalTo: separatorView.leftAnchor, constant: -30),
            weightStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            weightStackView.heightAnchor.constraint(equalToConstant: 80),
            weightStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            heightStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            heightStackView.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 30),
            heightStackView.heightAnchor.constraint(equalToConstant: 80),
            heightStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.backgroundColor = .white
    }
    
    
    
    //MARK: PUBLIC METHODS
    func configureCell(dimensionsViewModel: DimensionsCellViewModel){
        self.contentView.autoresizingMask = .flexibleHeight
        self.autoresizingMask = .flexibleHeight
        self.addSubviews()
        self.setupLayout()
        
        self.heightLabel.text = String(format: "%.2f m", dimensionsViewModel.height)
        self.heightLabel.textColor = dimensionsViewModel.mainColor
        
        self.heightProgressBar.setProgress(dimensionsViewModel.heightProgressValue, animated: true)
        self.heightProgressBar.progressTintColor = dimensionsViewModel.mainColor
        
        self.weightLabel.text = String(format: "%.2f Kg", dimensionsViewModel.weight)
        self.weightLabel.textColor = dimensionsViewModel.mainColor
        
        self.weightProgressBar.setProgress(dimensionsViewModel.weightProgressValue, animated: true)
        self.weightProgressBar.progressTintColor = dimensionsViewModel.mainColor
    }
    
}
