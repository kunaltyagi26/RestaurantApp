//
//  DetailsFoodVC.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 10/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit

class DetailsFoodVC: UIViewController {

    @IBOutlet weak var detailsFoodView: DetailsFoodView!
    
    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateView() {
        if let viewModel = viewModel {
            detailsFoodView.priceLabel?.text = viewModel.price
            detailsFoodView.ratingsLabel?.text = viewModel.rating
            detailsFoodView.hoursLabel.text = viewModel.isOpen
            detailsFoodView.locationLabel.text = viewModel.phoneNumber
        }
    }

}
