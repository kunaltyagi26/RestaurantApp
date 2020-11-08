//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 29/01/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

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
        
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the user location. \(error)")
            }
        }
        
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            guard let locationVC = storyboard.instantiateViewController(withIdentifier: "locationVC") as? LocationVC else { return false }
            locationVC.delegate = self
            window.rootViewController = locationVC
        default:
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationService.getLocation()
            (nav?.topViewController as? RestaurantTableVC)?.delegate = self
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func loadDetails(withId id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (strongSelf.navigationController?.topViewController as? DetailsFoodVC)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses.compactMap(RestaurantListViewModel.init).sorted(by: { $0.distance < $1.distance })
                
                if let nav = strongSelf.window.rootViewController as? UINavigationController, let restaurantListVC = nav.topViewController as? RestaurantTableVC {
                    restaurantListVC.viewModels = viewModels ?? []
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}

extension AppDelegate: LocationActions {
    func didTapAllow() {
        locationService.requestAuthorization()
    }
}

extension AppDelegate: ListActions {
    func didTapCell(_ viewModel: RestaurantListViewModel) {
        loadDetails(withId: viewModel.id)
    }
}

