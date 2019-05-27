//
//  DetailViewController.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/25/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    //MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var viewModel = DetailViewModel()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
            nameLabel.text = viewModel.name
            temperatureLabel.text = viewModel.temperature
            descriptionLabel.text = viewModel.description
            windDirectionLabel.text = viewModel.getCardinalDirection(degree: viewModel.windDirection)
            windSpeedLabel.text = "\(viewModel.windSpeed)mph"
            cloudinessLabel.text = "\(viewModel.cloudiness)%"

    }

}
