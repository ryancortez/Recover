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
    
    let announcementBeforeSession = "Beginning new session!"
    let announcementBeforeExercise = "Get Ready for "
    
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
        setNavBarTitle()
    }
    override func setupTableView() {
        super.setupTableView()
    }

    func setNavBarTitle() {
        if sessionIsActive {
            self.title = "0:00"
        } else {
            self.title = ""
        }
    }
    func setButtonStates() {
        setPreviousExerciseButtonState()
        setStartButtonState()
        setNextExerciseButtonState()
        setStopButtonState()
    }
    func setStopButtonState() {
        if sessionIsActive {
        } else {
            
        }
        
    }
    func setPreviousExerciseButtonState() {
        if (sessionIsActive) {
            previousButton.isEnabled = true
            previousButton.tintColor = nil
        } else {
            previousButton.isEnabled = false
            previousButton.tintColor = UIColor.clear
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
            startButton.title = "Start Session"
        }
    }
    func setNextExerciseButtonState() {
        if sessionIsActive{
            nextButton.isEnabled      = true
            nextButton.tintColor    = nil
        }else{
            nextButton.isEnabled      = false
            nextButton.tintColor    = UIColor.clear
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
        if (speechSynthesizer.isPaused) {
            speechSynthesizer.continueSpeaking()
        } else {
            continueSession()
        }
        setButtonStates()
        setNavBarTitle()
    }
    func pauseExerciseSession() {
        sessionIsPaused = true
        speechSynthesizer.pauseSpeaking(at: .immediate)
        setButtonStates()
    }
    func startExerciseSession() {
        sessionIsActive = true
        setButtonStates()
        setNavBarTitle()
        beginSession()
    }
    func goToPreviousExercise() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        if (exerciseIndex - 1 >= 0) {
            exercise = exercises[exerciseIndex - 1]
            exerciseIndex = exerciseIndex - 1
            if (exerciseIndex == 0) {
                isFirstExercise = true
                setButtonStates()
            }
            refreshTableViewData()
            checkIfSessionIsPaused()
        } else {
            continueSession()
        }
    }
    func goToNextExercise() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        if (exerciseIndex + 1 < exercises.count) {
            isFirstExercise = false
            setButtonStates()
            setNavBarTitle()
            exercise = exercises[exerciseIndex + 1]
            exerciseIndex = exerciseIndex + 1
            refreshTableViewData()
            checkIfSessionIsPaused()
        } else {
            delegate.stopButtonWasPressed()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK - Text-to-Speech -
    func setupSpeechSynthesizer() {
        speechSynthesizer.delegate = self
    }
    func speak(thisText text: String, withPreUtteranceDelay preUtteranceDelay: TimeInterval?, andPostUtterenceDelay postUtterenceDelay: TimeInterval?) {
        speak(thisText: text, withPreUtteranceDelay: preUtteranceDelay, andPostUtterenceDelay: postUtterenceDelay, withSpeakingRate: 0.43)
    }
    func speak(thisText text: String, withPreUtteranceDelay preUtteranceDelay: TimeInterval?, andPostUtterenceDelay postUtterenceDelay: TimeInterval?, withSpeakingRate rate: Float) {
        let speakUtterence = AVSpeechUtterance(string: text)

        if (preUtteranceDelay != nil) {
            speakUtterence.preUtteranceDelay = preUtteranceDelay!
        }
        if (postUtterenceDelay != nil) {
            speakUtterence.postUtteranceDelay = postUtterenceDelay!
        }
        speakUtterence.rate = rate
        speechSynthesizer.speak(speakUtterence)
    }
    func beginSession() {
        speak(thisText: "\(announcementBeforeSession)", withPreUtteranceDelay: 0.1, andPostUtterenceDelay: 0.0)
        announceExercise()
    }
    func continueSession() {
        announceExercise()
    }
    func announceExercise() {
        speak(thisText: "\(announcementBeforeExercise)", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
        speak(thisText: "\(exercise.name)", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.1)
        speak(thisText: "\(exercise.instructions)", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
        announceReps()
        announceExerciseTime()
        var timeInterval: TimeInterval = 1.0
        if (exercise.time != 0) {
            timeInterval = Double(exercise.time)
        }
        readyAnnouncement(withExerciseTimeInterval: timeInterval)
        countdownAnnouncement()
        if (exerciseIndex + 1 == exercises.count) {
            endingAnnouncement()
        }
    }
    func announceReps() {
        if (exercise.reps != 0) {
            speak(thisText: "Perform this exercise \(exercise.reps) times", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
        }
    }
    func announceExerciseTime() {
        if (exercise.time != 0) {
            var timeString: String = ""
            if (exercise.time >= 60) {
                if (exercise.time == 60) {
                    timeString = "\(exercise.time / 60) minute"
                } else {
                    timeString = "\(exercise.time / 60) minutes"
                }
            } else {
                timeString = "\(exercise.time) seconds"
            }
            if (exercise.reps != 0) {
               speak(thisText: "within \(timeString)", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
            } else {
              speak(thisText: "Perform this exercise for \(timeString)", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
            }
        }
    }
    func countdownAnnouncement() {
        speak(thisText: "5", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.04)
        speak(thisText: "4", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.04)
        speak(thisText: "3", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.04)
        speak(thisText: "2", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.04)
        speak(thisText: "1", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.04)
    }
    func readyAnnouncement(withExerciseTimeInterval timeInterval: TimeInterval) {
         speak(thisText: "Ready?", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0)
         speak(thisText: "Let's Begin", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: timeInterval)
    }
    func endingAnnouncement() {
        speak(thisText: "Ending session. Great job!", withPreUtteranceDelay: 0.0, andPostUtterenceDelay: 0.0, withSpeakingRate: 0.52)
    }
    
    // MARK: AVSpeechSynthesizer Delegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (utterance.speechString == "1") {
            goToNextExercise()
        }
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        delegate.stopButtonWasPressed()
        sessionIsActive = false
        setButtonStates()
        speechSynthesizer.stopSpeaking(at: .immediate)
        self.dismiss(animated: true, completion: nil)
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
