//
//  SavedExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import AVFoundation

protocol SavedExerciseDetailTableViewControllerDelegate {
    func stopButtonWasPressed()
}

class SavedExerciseDetailTableViewController: ExerciseDetailTableViewController, AVSpeechSynthesizerDelegate {
    
    // MARK: - Global Variables
    var exerciseIndex: Int!
    var sessionIsActive: Bool = false
    var sessionIsPaused: Bool = false
    var isFirstExercise: Bool = true
    var nextButtonWasPressed: Bool = false
    let speechSynthesizer = AVSpeechSynthesizer()
    var delegate: SavedExerciseDetailTableViewControllerDelegate!
    
    let announcmentBeforeSession = "Beginning new Physical Therapy Session"
    let announcementBeforeExercise = "Get Ready for "
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    // MARK: - Inital Setup -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSpeechSynthesizer()
        checkIfSessionIsActive()
        setButtonStates()
    }
    
    func setButtonStates() {
        setPreviousExerciseButtonState()
        setStartButtonState()
        setNextExerciseButtonState()
        setStopButtonState()
        setEditButtonState()
    }
    func setStopButtonState() {
        if sessionIsActive {
        } else {
            
        }
        
    }
    func setEditButtonState() {
        if sessionIsActive {
            editButton.enabled = false
            editButton.tintColor = UIColor.clearColor()
        } else {
            editButton.enabled = true
            editButton.tintColor = nil
        }
    }
    func setPreviousExerciseButtonState() {
        if (sessionIsActive && isFirstExercise == false) {
            previousButton.enabled = true
            previousButton.tintColor = nil
        } else {
            previousButton.enabled = false
            previousButton.tintColor = UIColor.clearColor()
        }
    }
    func setStartButtonState() {
        if sessionIsActive {
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
        if sessionIsActive{
            nextButton.enabled      = true
            nextButton.tintColor    = nil
        }else{
            nextButton.enabled      = false
            nextButton.tintColor    = UIColor.clearColor()
        }
    }
    
    // MARK: - Exercise Session Logic -
    func checkIfSessionIsActive() {
        if sessionIsActive {
            checkIfSessionIsPaused()
        }
    }
    func checkIfSessionIsPaused() {
        if sessionIsPaused {
            pauseExerciseSession()
        } else {
            checkIfThisIsTheFirstExercise()
        }
    }
    func checkIfThisIsTheFirstExercise() {
        if isFirstExercise {
            beginSession()
        } else {
            continueSession()
        }
    }
    func resumeExerciseSession() {
        sessionIsPaused = false
        if (speechSynthesizer.paused) {
            speechSynthesizer.continueSpeaking()
        } else {
            continueSession()
        }
        setButtonStates()
    }
    func pauseExerciseSession() {
        sessionIsPaused = true
        speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
        setButtonStates()
    }
    func startExerciseSession() {
        sessionIsActive = true
        setButtonStates()
        beginSession()
    }
    func goToPreviousExercise() {
        speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        if (exerciseIndex - 1 >= 0) {
            exercise = exercises[exerciseIndex - 1]
            exerciseIndex = exerciseIndex - 1
            if (exerciseIndex == 0) {
                isFirstExercise = true
                setButtonStates()
            }
            tableView.reloadData()
            checkIfSessionIsPaused()
        } else {
            delegate.stopButtonWasPressed()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func goToNextExercise() {
            speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        if (exerciseIndex + 1 < exercises.count) {
            isFirstExercise = false
            setButtonStates()
            exercise = exercises[exerciseIndex + 1]
            exerciseIndex = exerciseIndex + 1
            tableView.reloadData()
            checkIfSessionIsPaused()
        } else {
            delegate.stopButtonWasPressed()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func previousExerciseButtonWasPressed() {
        
    }
    
    // MARK - Text-to-Speech - 
    func setupSpeechSynthesizer() {
        speechSynthesizer.delegate = self
    }
    func speak(thisText text: String) {
        let speakUtterence = AVSpeechUtterance(string: text)
        speakUtterence.rate = 0.42
        speechSynthesizer.speakUtterance(speakUtterence)
    }
    func beginSession() {
        let text = "\(announcmentBeforeSession) \(announcementBeforeExercise) \(exercise.name) \(exercise.instructions)"
        speak(thisText: text)
    }
    func continueSession() {
        let text = "\(announcementBeforeExercise) \(exercise.name) \(exercise.instructions)"

        speak(thisText: text)
    }
    
    // MARK: AVSpeechSynthesizer Delegate
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        goToNextExercise()
    }
    
    // MARK: - TableView -
    
    // MARK: TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        
            if (exercise.reps != 0 || exercise.time != 0) {
                count += 1
            }
            if (exercise.instructions != "") {
                count += 1
            }
        return count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return createTitleCell(withIndexPath: indexPath)
        case 1:
            if (exercise.reps != 0 || exercise.time != 0) {
                return createRepsAndTimeLabelCell(withIndexPath: indexPath)
            }
            else if (exercise.instructions != "") {
                return createInstructionCell(withIndexPath: indexPath)
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        delegate.stopButtonWasPressed()
        sessionIsActive = false
        setButtonStates()
        speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
    }
    @IBAction func previousButtonPressed(sender: AnyObject) {
        goToPreviousExercise()
    }
    @IBAction func startButtonPressed(sender: AnyObject) {
        if sessionIsActive {
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
        goToNextExercise()
    }
    
}
