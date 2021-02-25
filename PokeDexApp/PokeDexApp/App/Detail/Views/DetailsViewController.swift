//
//  DetailsViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class DetailsViewController: UIViewController {
    private var detailsViewModel: DetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
    
    public func configureDetailView(with detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.detailsViewModel?.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewController")
    }

}
