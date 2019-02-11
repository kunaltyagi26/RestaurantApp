//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 29/01/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            guard let locationVC = storyboard.instantiateViewController(withIdentifier: "locationVC") as? LocationVC else { return false }
            locationVC.locationService = locationService
            window.rootViewController = locationVC
        default:
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            loadBusinesses()
        }
        window.makeKeyAndVisible()
        
        return true
    }

    private func loadBusinesses() {
        service.request(.search(lat: 42.361145, long: -71.057083)) { (result) in
            switch result {
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses.compactMap(RestaurantListViewModel.init)
                
                if let nav = self.window.rootViewController as? UINavigationController, let restaurantListVC = nav.topViewController as? RestaurantTableVC {
                    restaurantListVC.viewModels = viewModels ?? []
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}

