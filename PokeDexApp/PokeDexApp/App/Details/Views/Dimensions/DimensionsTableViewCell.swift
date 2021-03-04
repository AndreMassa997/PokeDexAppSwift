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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        return stackView
    }()
    
    let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        return stackView
    }()
    
    let weightProgressBar: UIProgressView = UIProgressView()
    let heightProgressBar: UIProgressView = UIProgressView()
 
    
    //MARK: PRIVATE METHODS
    //Add subviews to the contentView
    private func addSubviews(){
        leftStackView.addArrangedSubview(weightTitleLabel)
        leftStackView.addArrangedSubview(weightLabel)
        leftStackView.addArrangedSubview(weightProgressBar)
        rightStackView.addArrangedSubview(heightTitleLabel)
        rightStackView.addArrangedSubview(heightLabel)
        rightStackView.addArrangedSubview(heightProgressBar)
        self.contentView.addSubview(leftStackView)
        self.contentView.addSubview(rightStackView)
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
            
            leftStackView.rightAnchor.constraint(equalTo: separatorView.leftAnchor, constant: -30),
            leftStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            leftStackView.heightAnchor.constraint(equalToConstant: 80),
            leftStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            rightStackView.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 30),
            rightStackView.heightAnchor.constraint(equalToConstant: 80),
            rightStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.backgroundColor = .white
    }
    
    
    
    //MARK: PUBLIC METHODS
    func configureCell(dimensionsViewModel: DimensionsViewModel){
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
