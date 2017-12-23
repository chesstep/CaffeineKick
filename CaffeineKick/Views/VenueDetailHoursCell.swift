//
//  VenueDetailHoursCell.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import UIKit

class VenueDetailHoursCell: UITableViewCell {
    
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    override func awakeFromNib() {
        hoursTitleLabel.text = NSLocalizedString("Hours", comment: "")
    }
}
