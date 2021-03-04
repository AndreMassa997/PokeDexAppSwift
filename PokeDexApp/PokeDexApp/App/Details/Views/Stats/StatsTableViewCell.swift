//
//  StatsTableViewCell.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    static let reusableId = "StatsTableViewCell"
    
    private let statNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = UIProgressView()
    
    //MARK: PRIVATE METHODS
    //Add subviews to the contentView
    private func addSubviews(){
        self.contentView.addSubview(statNameLabel)
        self.contentView.addSubview(valueLabel)
        self.contentView.addSubview(progressBar)
    }
    
    //Setup UI and constraints of pokemon cell
    private func setupLayout(){
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //stat name constraint
            statNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            statNameLabel.widthAnchor.constraint(equalToConstant: 40),
            statNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //value label constraint
            valueLabel.leftAnchor.constraint(equalTo: statNameLabel.rightAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 30),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 16),
            
            //progress bar constraint
            progressBar.leftAnchor.constraint(equalTo: valueLabel.rightAnchor, constant: 10),
            progressBar.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 6),
        ])
        contentView.backgroundColor = .white
    }
    
    //MARK: PUBLIC METHODS
    //Pokemon stat configuration
    public func configureStatCell(statViewModel: StatViewModel){
        self.contentView.autoresizingMask = .flexibleHeight
        self.autoresizingMask = .flexibleHeight
        self.addSubviews()
        self.setupLayout()
        
        self.statNameLabel.text = statViewModel.statName
        self.statNameLabel.textColor = statViewModel.mainColor
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        self.valueLabel.text = formatter.string(from: NSNumber(value: statViewModel.statValue))
        
        self.progressBar.setProgress(statViewModel.progressValue, animated: true)
        self.progressBar.progressTintColor = statViewModel.mainColor
    }
}
