//
//  WeatherDataModel.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/24/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

struct WeatherDataModel {
    var cityName = ""
    var temp: String = ""
    var windSpeed: String = ""
    var windDirection: String = ""
    
    var cloudiness: String = ""
    var icon: UIImage? = nil
    var iconID: String = ""
    var description = ""
}

/// Realm Object that can be stored and retrieved.
class UserSavedCities: Object{
    @objc dynamic var name = ""
}
