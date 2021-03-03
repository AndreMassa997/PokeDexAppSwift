//
//  DimensionTableViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 03/03/21.
//

import UIKit

final class DimensionsTableViewCell: UITableViewCell{
    static let reusableId = "DimensionTableViewCell"
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
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
    
    let leftViewContainer: UIView = UIView()
    let rightViewContainer: UIView = UIView()
 
    
    //MARK: PRIVATE METHODS
    //Add subviews to the contentView
    private func addSubviews(){
        leftViewContainer.addSubview(weightLabel)
        rightViewContainer.addSubview(heightLabel)
        self.contentView.addSubview(leftViewContainer)
        self.contentView.addSubview(rightViewContainer)
        self.contentView.addSubview(separatorView)
    }
    
    //Setup UI and constraints of cell
    private func setupLayout(){
        leftViewContainer.translatesAutoresizingMaskIntoConstraints = false
        rightViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            //line separator view
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 100),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            leftViewContainer.rightAnchor.constraint(equalTo: separatorView.leftAnchor, constant: -20),
            leftViewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            leftViewContainer.heightAnchor.constraint(equalToConstant: 80),
            leftViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightViewContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            rightViewContainer.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 20),
            rightViewContainer.heightAnchor.constraint(equalToConstant: 80),
            rightViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //weight label inside left view container
            weightLabel.leftAnchor.constraint(equalTo: leftViewContainer.leftAnchor),
            weightLabel.rightAnchor.constraint(equalTo: leftViewContainer.rightAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: leftViewContainer.centerYAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: 30),
            
            //height label inside right view container
            heightLabel.leftAnchor.constraint(equalTo: rightViewContainer.leftAnchor),
            heightLabel.rightAnchor.constraint(equalTo: rightViewContainer.rightAnchor),
            heightLabel.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
            heightLabel.heightAnchor.constraint(equalToConstant: 30),
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
        self.weightLabel.text = String(format: "%.2f Kg", dimensionsViewModel.weight)
    }
    
}
