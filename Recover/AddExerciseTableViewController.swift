//
//  AddExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class AddExerciseTableViewController: BasicTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("TextViewCell", forIndexPath: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddPhotoCell", forIndexPath: indexPath)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
    }
}
