//
//  Models.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 11/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import Foundation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let name: String
    let imageUrl: URL
    let distance: String
    let id: String
}

extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.imageUrl = business.imageUrl
        self.distance = "\(business.distance / 1609.344)"
        self.id = business.id
    }
}
