//
//  LocationVC.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 10/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit

protocol LocationActions: class {
    func didTapAllow()
}

class LocationVC: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    
    weak var delegate: LocationActions?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationView.didTapAllow = { [weak self] in
            self?.delegate?.didTapAllow()
        }
    }

}
