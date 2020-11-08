//
//  RestaurantTableViewCell.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 10/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var markerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: RestaurantListViewModel) {
        self.restaurantImageView.af_setImage(withURL: viewModel.imageUrl)
        self.restaurantNameLabel.text = viewModel.name
        self.locationLabel.text = viewModel.formattedDistance
    }
}
