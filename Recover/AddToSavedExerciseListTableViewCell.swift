//
//  AddToSavedExerciseListTableViewCell.swift
//  Recover
//
//  Created by Ryan Cortez on 8/19/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

protocol AddToSavedExerciseListTableViewCellDelegate {
    func addToSavedExerciseListButtonPressed()
}

class AddToSavedExerciseListTableViewCell: UITableViewCell {

    var delegate: AddToSavedExerciseListTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToSavedExerciseListButtonPressed(sender: AnyObject) {
        delegate.addToSavedExerciseListButtonPressed()
    }
}
