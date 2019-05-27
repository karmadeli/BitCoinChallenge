//
//  NetworkingClient.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class NetworkingClient {
    
    static let shared = NetworkingClient()
    
    /// Configures and returns the parameter for API call to OpenWeatherMaps.
    /// It accepts a city or lat and lon coordinates.
    func params(city:  String? = nil, lat: String? = nil, lon: String? = nil) -> [String:String] {
        let appID = "a5a1dac1431e30ad8c5453f69202008a"
        if let city = city{
            return ["q":city, "appID":appID, "units":"imperial"]
        }else{
            if let lat = lat, let lon = lon{
                return ["lat" : lat, "lon" : lon, "appID":appID, "units":"imperial"]
            }
        }
        return [:]
    }
    
    //Networking
    func getData(with params: [String: String], completion: @escaping (WeatherDataModel)->()) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { [weak self] (response)  in
            if response.result.isSuccess {
                //model your data
                var weatherData = WeatherDataModel()
                guard let value = response.result.value as? [String : Any] else { return}
                if let name = value["name"] as? String {
                    weatherData.cityName = name
                }else { print("Failed to get name.") }
                if let main = value["main"] as? [String : Any], let temp = main["temp"] as? Double {
                    weatherData.temp = "\(String(Int(temp.rounded())))°F"
                }else { print("Failed to get main weather data.") }
                if let clouds = value["clouds"] as? [String: Any], let cloudiness = clouds["all"] as? Int {
                    weatherData.cloudiness = String(cloudiness)
                }else { print("Failed to get cloud data.") }
                if let wind = value["wind"] as? [String: Any], let speed = wind["speed"] as? Double, let degrees = wind["deg"] as? Int {
                    weatherData.windSpeed = String(speed)
                    weatherData.windDirection = String(degrees)
                }else { print("Failed to get wind data.") }
                if let weatherArray = value["weather"] as? NSArray, let weatherDict = weatherArray[0] as? [String : Any], let desc = weatherDict["description"] as? String, let icon = weatherDict["icon"] as? String {
                    weatherData.description = desc
                    weatherData.iconID = icon
                    //get icon image
                    self?.getIconImage(id: icon, completion: { (image) in
                        DispatchQueue.main.async {
                            weatherData.icon = image
                            completion(weatherData)
                         }
                    })
                }
                else{
                    print("Failed to get weather icon and description data.")
                }
            }else { print("Failed to get response result: ", response.error as Any) }
        }
     }
    
    private func getIconImage(id: String, completion: @escaping (UIImage)->()){
        let url = "http://openweathermap.org/img/w/\(id).png"
        Alamofire.request(url).responseImage { (response) in
            if response.result.isSuccess {
                if let image = response.result.value {
                    completion(image)
                }
            }else {
                print(response.error as Any)
            }
        }
    }
    
}
