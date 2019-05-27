//
//  WeatherCell.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/24/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
