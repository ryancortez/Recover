//
//  SavedExerciseListTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class SavedExerciseListTableViewController: BasicTableViewController {
    
    // MARK: - Global Variables
    var previousExerciseButtonIsHidden: Bool = true
    var sessionIsActivate: Bool = false
    var sessionIsPaused: Bool = true
    var nextExerciseButtonIsHidden: Bool = true
    
    // MARK: - Outlet
    @IBOutlet weak var previousExerciseButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var nextExerciseButton: UIBarButtonItem!
    
    // MARK: - Inital Setup
    
    override func viewDidLoad() {
        
    }
    
    func setToolbarButtonStates() {
        setPreviousExerciseButtonState()
        setStartButtonState()
        setNextExerciseButtonState()
    }
    
    func setPreviousExerciseButtonState() {
        if previousExerciseButtonIsHidden{
            previousExerciseButton.enabled      = false
            previousExerciseButton.tintColor    = UIColor.clearColor()
        }else{
            previousExerciseButton.enabled      = true
            previousExerciseButton.tintColor    = nil
        }
    }
    
    func setStartButtonState() {
        if sessionIsActivate {
            if sessionIsPaused {
                startButton.title = "Resume"
            } else {
                startButton.title = "Pause"
            }
        } else {
            startButton.title = "Start"
        }
    }
    
    func setNextExerciseButtonState() {
        if nextExerciseButtonIsHidden{
            nextExerciseButton.enabled      = false
            nextExerciseButton.tintColor    = UIColor.clearColor()
        }else{
            nextExerciseButton.enabled      = true
            nextExerciseButton.tintColor    = nil
        }
    }

    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Exercise Name"
        return cell
    }
    
    // MARK: - Logic 
    func resumeExerciseSession() {
        
    }
    
    func pauseExerciseSession() {
        
    }
    
    func startExerciseSession() {
        
    }
    
    // MARK: - Actions
    @IBAction func previousExerciseButtonPressed(sender: AnyObject) {
    }
    @IBAction func startButtonPressed(sender: AnyObject) {
        if sessionIsActivate {
            if sessionIsPaused {
                resumeExerciseSession()
            } else {
                pauseExerciseSession()
            }
        } else {
            startExerciseSession()
        }
    }
    @IBAction func nextExerciseButtonPressed(sender: AnyObject) {
    }

}
