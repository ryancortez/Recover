//
//  SavedExerciseTableViewCell.swift
//  Recover
//
//  Created by Ryan Cortez on 8/22/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class SavedExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var repsView: UIStackView!
    @IBOutlet weak var timeView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        removeAllViewsExceptName()
    }
    
    func removeAllViewsExceptName() {
        arrowImageView.removeFromSuperview()
        repsView.removeFromSuperview()
        timeView.removeFromSuperview()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
