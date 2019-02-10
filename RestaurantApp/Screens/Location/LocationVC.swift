//
//  LocationVC.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 10/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit

class LocationVC: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    
    var locationService: LocationService?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationView.didTapAllow = { [weak self] in
            self?.locationService?.requestAuthorization()
        }
        
        locationService?.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService?.getLocation()
            }
        }
        
        locationService?.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                print(location)
            case .failure(let error):
                assertionFailure("Error getting the user location. \(error)")
            }
        }
    }

}
