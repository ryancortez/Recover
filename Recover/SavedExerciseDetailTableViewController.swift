//
//  SavedExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class SavedExerciseDetailTableViewController: BasicTableViewController {
    
    // MARK: - Global Variables
    var sessionIsActivate: Bool = false
    var sessionIsPaused: Bool = false
    
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    // MARK: - Inital Setup
    override func viewDidLoad() {
        let navBarTitle = "Selected Exercise"
        self.title = navBarTitle
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
            previousButton.enabled = true
            previousButton.tintColor = nil
        } else {
            previousButton.enabled = false
            previousButton.tintColor = UIColor.clearColor()
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
            nextButton.enabled      = true
            nextButton.tintColor    = nil
        }else{
            nextButton.enabled      = false
            nextButton.tintColor    = UIColor.clearColor()
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
    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.textLabel?.text = "Exercise Details"
        return cell
    }
    @IBAction func stopButtonPressed(sender: AnyObject) {
        sessionIsActivate = false
        setButtonStates()
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
    }
    @IBAction func previousButtonPressed(sender: AnyObject) {
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
    @IBAction func nextButtonPressed(sender: AnyObject) {
    }
    
}
