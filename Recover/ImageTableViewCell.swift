//
//  ImageTableViewCell.swift
//  Recover
//
//  Created by Ryan Cortez on 8/16/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
