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
    var sessionIsActivate: Bool = false
    var sessionIsPaused: Bool = false
    
    // MARK: - Outlet
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var previousExerciseButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var nextExerciseButton: UIBarButtonItem!
    @IBOutlet weak var reorderButton: UIBarButtonItem!
    
    // MARK: - Inital Setup
    
    override func viewDidLoad() {
        setButtonStates()
    }
    
    func setButtonStates() {
        setPreviousExerciseButtonState()
        setStartButtonState()
        setNextExerciseButtonState()
        setStopButtonState()
    }
    
    func setStopButtonState() {
        if sessionIsActivate {
            stopButton.enabled = true
            stopButton.tintColor = nil
        } else {
            stopButton.enabled = false
            stopButton.tintColor = UIColor.clearColor()
        }

    }
    
    func setPreviousExerciseButtonState() {
        if sessionIsActivate {
            previousExerciseButton.enabled = true
            previousExerciseButton.tintColor = nil
        } else {
            previousExerciseButton.enabled = false
            previousExerciseButton.tintColor = UIColor.clearColor()
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
        if sessionIsActivate{
            nextExerciseButton.enabled      = true
            nextExerciseButton.tintColor    = nil
        }else{
            nextExerciseButton.enabled      = false
            nextExerciseButton.tintColor    = UIColor.clearColor()
        }
    }
    
    // MARK: - Exercise Session Logic
    func resumeExerciseSession() {
        sessionIsPaused = false
        setButtonStates()
    }
    
    func pauseExerciseSession() {
        sessionIsPaused = true
        setButtonStates()
    }
    
    func startExerciseSession() {
        sessionIsActivate = true
        setButtonStates()
    }

    
    // MARK: - TableView
    
    // MARK: Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Exercise Name"
        return cell
    }
    
    // MARK: Delegate
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    // MARK: - Actions
    @IBAction func stopButtonPressed(sender: AnyObject) {
        sessionIsActivate = false
        setButtonStates()
    }
    @IBAction func reorderButtonPressed(sender: AnyObject) {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            reorderButton.title = "Reorder"
            reorderButton.style = .Plain
        } else {
            tableView.setEditing(true, animated: true)
            reorderButton.title = "Done"
            reorderButton.style = .Done
        }
    }
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
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "savedListToDetail") {
            guard let destination = segue.destinationViewController as? SavedExerciseDetailTableViewController else {
                fatalError("Did not find SavedExerciseDetailTableViewController in segue.destinationViewController")
            }
            destination.sessionIsActivate = self.sessionIsActivate
            destination.sessionIsPaused = self.sessionIsPaused
        }
    }

}
