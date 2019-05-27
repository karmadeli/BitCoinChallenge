//
//  AlertInputService.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import UIKit

/// Presents an Alert ViewController that allows the user to enter a city
/// to ultimately get the weather data for that city.
class AlertInputService {
    
    static func addCity(vc: UIViewController, completion: @escaping (_ city: String)->()){
        let alert = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            guard let city = alert.textFields?.first?.text else {return}
            completion(city)
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.present(alert, animated: true)
    }
}
