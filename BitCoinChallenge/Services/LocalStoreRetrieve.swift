//
//  LocalStoreRetrieve.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import  UIKit

/// Saves the city the user adds to persistent local memory via RealmSwift.
class LocalStoreRetrieve {
    static let shared = LocalStoreRetrieve()
    
    func saveCity(vc: UIViewController, vm: WeatherDataViewModel){
        AlertInputService.addCity(vc: vc) { (city) in
            if city != ""{
                NetworkingClient.shared.getData(with: NetworkingClient.shared.params(city: city), completion: { (weatherData) in
                    if weatherData.cityName != "" {
                        vm.dataSource.append(weatherData)
                        let userCity = UserSavedCities()
                        userCity.name = weatherData.cityName
                        RealmCRUDService.shared.create(realmObject: userCity)
                    }else{
                        print("Didnt save city")
                    }
                })
            }
        }
    }
    
}
