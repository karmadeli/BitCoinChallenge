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
    
    var dataSource = [WeatherDataModel]()
    let dispatchGroup = DispatchGroup()
    var savedCities: Results<UserSavedCities>?
    var locationClient: LocationClient?
    
    init(){
        self.locationClient = LocationClient()
    }

    func getLatLon(completion: @escaping (String, String)->()){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LatLon"), object: nil, queue: nil) { (notification) in
            guard let data = notification.userInfo else {return}
            guard let lat = data["lat"] as? String else{ return }
            guard let lon = data["lon"] as? String else { return }
            completion(lat, lon)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("LatLon"), object: nil)
        }
        
    }
    
    func getSavedCities(){
        savedCities = RealmCRUDService.shared.realm?.objects(UserSavedCities.self)
        if let cities = savedCities{
            for city in cities{
                getData(with: NetworkingClient.shared.params(city: city.name))
            }
        }
    }
 
    func setTitleView(navItem: UINavigationItem){
        let logo = UIImage(named: "bitcoin")
        let titleImageView  = UIImageView(image: logo)
        navItem.titleView = titleImageView
    }
    
    func getData(with params: [String:String]){
        dispatchGroup.enter()
        NetworkingClient.shared.getData(with: params) { [weak self]  (weatherData) in
            if params["q"] == nil{
                self?.dataSource.insert(weatherData, at: 0)
            }else{
                self?.dataSource.append(weatherData)
            }
            self?.dispatchGroup.leave()
        }
        
    }
   
}

