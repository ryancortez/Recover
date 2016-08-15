//
//  AddExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

protocol AddExerciseTableViewControllerDelegate {
    func saveNew(exercise: Exercise)
}

class AddExerciseTableViewController: ExerciseTableViewController {
    
    var delegate: AddExerciseTableViewControllerDelegate!
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
    }
}
