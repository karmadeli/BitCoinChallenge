//
//  WeatherDataViewModel.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/24/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherDataViewModel {
    
    private var locationClient: LocationClient?
    private var savedCities: Results<UserSavedCities>?
    var dataSource = [WeatherDataModel]()
    let dispatchGroup = DispatchGroup()
    var lat: String?
    var lon: String?
    
    init(){
        self.locationClient = LocationClient()
    }
    
    func getLatLon(completion: @escaping (String?, String?)->()) {
        determineLatLon { (lat, lon) in
            completion(lat, lon)
        }
    }
    
    ///Determines whether to use coordinates from the locationClient or stored properties.
    private func determineLatLon(completion: @escaping (String?, String?)->()) {
        if self.lat == nil || self.lon == nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.LatLon, object: nil, queue: nil) { [weak self] (notification) in
                if let data = notification.userInfo, let lat = data["lat"] as? String, let lon = data["lon"] as? String{
                    self?.lat = lat
                    self?.lon = lon
                    completion(lat, lon)
                }
            }
        }else {
            completion(self.lat, self.lon)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.LatLon, object: LocationClient.self)
    }
    
    func getSavedCities() {
        savedCities = RealmCRUDService.shared.realm?.objects(UserSavedCities.self)
        if let cities = savedCities{
            for city in cities{
                getData(with: NetworkingClient.shared.params(city: city.name))
            }
        }
    }
 
    func setTitleView(navItem: UINavigationItem) {
        let logo = UIImage(named: "bitcoin")
        let titleImageView  = UIImageView(image: logo)
        navItem.titleView = titleImageView
    }
    
    func getData(with params: [String:String]) {
        dispatchGroup.enter()
        NetworkingClient.shared.getData(with: params) { [weak self] (weatherData) in
            if params["q"] == nil {
                self?.dataSource.insert(weatherData, at: 0)
            }else{
                self?.dataSource.append(weatherData)
            }
            self?.dispatchGroup.leave()
        }
    }
    
}

