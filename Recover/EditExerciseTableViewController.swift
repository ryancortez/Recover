//
//  EditExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

protocol EditExerciseTableViewControllerDelegate {
    func saveNew(exercise: ExerciseViewModel)
    func edit(currentExercise currentExercise: Exercise, withNewExerciseData newExerciseData: ExerciseViewModel)
}

class EditExerciseTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Global Variables
    var exercise: Exercise!
    var delegate: EditExerciseTableViewControllerDelegate!
    var isFirstTimeExerciseDescriptionIsBeginningEditing: Bool  = true
    
    // MARK: - Outlets
    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var exerciseInstructions: UITextView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var numberOfReps: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    @IBOutlet weak var repStepper: UIStepper!
    @IBOutlet weak var timeStepper: UIStepper!
    
    // MARK: - Inital Setup
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        setupNavBar()
        setupTitle()
        setupInstructions()
        setupSteppers()
    }
    func setupNavBar() {
        if (exercise != nil) {
            self.title = "Edit " + "\"\(exercise.name)\""
        } else {
            self.title = "Add Exercise"
        }
    }
    func setupTitle() {
        if (exercise != nil) {
            exerciseTitle.text = exercise.name
        }
    }
    func setupInstructions() {
        if (exercise != nil) {
            exerciseInstructions.textColor = UIColor.blackColor()
            exerciseInstructions.text = exercise.instructions
        }
    }
    func setupSteppers() {
        setupTimeStepper()
        setupRepStepper()
    }
    func setupTimeStepper() {
        timeStepper.maximumValue = 6000
        
        if (exercise != nil) {
            timeStepper.value = 30
            timeStepper.stepValue = 30
            if (exercise.time == 0) {
                 timeStepper.value = Double(exercise.time)
            }
        }
    }
    func setupRepStepper() {
        repStepper.maximumValue = 99

        if (exercise != nil) {
            if (exercise.reps == 0) {
                repStepper.value = 1
            } else {
                repStepper.value = Double(exercise.reps)
            }
        }
    }
    
    // MARK: - TextView Delegate
    func textViewDidBeginEditing(textView: UITextView) {
        if isFirstTimeExerciseDescriptionIsBeginningEditing {
            isFirstTimeExerciseDescriptionIsBeginningEditing = false
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        resignFirstResponderFromAllFieldsAndViews()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        exerciseTitle.resignFirstResponder()
        exerciseInstructions.resignFirstResponder()
        guard let name = exerciseTitle.text else {
            print("Did not retrieve a exercise name")
            return
        }
        guard let instructions = exerciseInstructions.text else {
            print("Did not retrieve any exercise instructions")
            return
        }
        let exerciseViewModel = ExerciseViewModel(name: name, image: nil, instructions: instructions, reps: nil, time: nil)
        if (exercise == nil) {
            delegate.saveNew(exerciseViewModel)
        } else {
            delegate.edit(currentExercise:exercise, withNewExerciseData: exerciseViewModel)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func repStepperPressed(sender: AnyObject) {
        numberOfReps.text = "\(Int(repStepper.value))"
        print(repStepper.value)
    }
    @IBAction func timeStepperPressed(sender: AnyObject) {
        print(timeStepper.value)
        
        if (timeStepper.value <= 30) {
            timeStepper.stepValue = 30
            exerciseTime.text = "\(Int(timeStepper.value)) sec"
        } else {
            timeStepper.stepValue = 60
            
            let minutes = floor(timeStepper.value/60)
            let seconds = round(timeStepper.value - minutes * 60)
            
            if (seconds <= 0) {
                exerciseTime.text = "\(Int(minutes)) min"
            } else {
                exerciseTime.text = "\(Int(minutes)) min \(Int(seconds)) sec"
            }
        }
    }
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
    }
    
    // MARK: - Switching Views
    func resignFirstResponderFromAllFieldsAndViews() {
        exerciseTitle.resignFirstResponder()
        exerciseInstructions.resignFirstResponder()
    }
}
