//
//  DetailViewModel.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation

class DetailViewModel {
   
    var name: String = ""
    var temperature: String = ""
    var description: String = ""
    var cloudiness: String = ""
    var windDirection: String = ""
    var windSpeed: String = ""
    
    func setup(model: WeatherDataModel) -> DetailViewModel {
        name = model.cityName
        windSpeed = model.windSpeed
        windDirection = model.windDirection
        cloudiness = model.cloudiness
        description = model.description
        temperature = model.temp
        return self
    }
    ///Takes the degree value and returns one of the 8 main cardinal points.
    func getCardinalDirection(degree: String)-> String {
        guard let degree = Int(degree) else {return ""}
        switch degree {
        case 338...360: return "N"
        case 0...23: return "N"
        case 24...68: return "NE"
        case 69...112: return "E"
        case 113...158: return "SE"
        case 159...203: return "S"
        case 204...248: return "SW"
        case 249...293: return "W"
        case 294...337: return "NW"
        default:
            return ""
        }
    }
    
}
