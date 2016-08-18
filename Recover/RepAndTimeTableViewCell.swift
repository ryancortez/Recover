//
//  RepAndTimeTableViewCell.swift
//  Recover
//
//  Created by Ryan Cortez on 8/16/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class RepAndTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repsCounts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
