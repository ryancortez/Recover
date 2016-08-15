//
//  EditExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class EditExerciseTableViewController: ExerciseTableViewController {

    // MARK: - Inital Setup
    override func viewDidLoad() {
        self.title = "Edit Exercise"
    }
    
    // MARK: - TableView Data Source
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
    }
}
