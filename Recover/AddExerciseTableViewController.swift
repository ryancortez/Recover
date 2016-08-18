//
//  AddExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

protocol AddExerciseTableViewControllerDelegate {
    func saveNew(exercise: ExerciseViewModel)
}

class AddExerciseTableViewController: UITableViewController, UITextViewDelegate {
    
    var delegate: AddExerciseTableViewControllerDelegate!
    var isFirstTimeExerciseDescriptionIsBeginningEditing: Bool  = true
    
    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var exerciseDescription: UITextView!
    @IBOutlet weak var numberOfReps: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var repStepper: UIStepper!
    @IBOutlet weak var timeStepper: UIStepper!
    
    // MARK: - Inital Setup
    override func viewDidLoad() {
        setupSteppers()
        exerciseDescription.delegate = self
    }
    
    func setupSteppers() {
        setupTimeStepper()
        setupRepStepper()
    }
    
    func setupTimeStepper() {
        timeStepper.value = 30
        timeStepper.stepValue = 30
        timeStepper.maximumValue = 6000
    }
    
    func setupRepStepper() {
        repStepper.value = 1
        repStepper.maximumValue = 99
    }
    
    func resignFirstResponderFromAllFieldsAndViews() {
        exerciseTitle.resignFirstResponder()
        exerciseDescription.resignFirstResponder()
    }
    
    // MARK: - TextView Delegate 
    
    // The first time that the Exercise Description gets edited it should clear, just like a textfield
    func textViewDidBeginEditing(textView: UITextView) {
        if isFirstTimeExerciseDescriptionIsBeginningEditing {
            isFirstTimeExerciseDescriptionIsBeginningEditing = false
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - Action
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        exerciseTitle.resignFirstResponder()
        exerciseDescription.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        exerciseTitle.resignFirstResponder()
        exerciseDescription.resignFirstResponder()
        guard let name = exerciseTitle.text else {
            return
        }
        guard let instructions = exerciseDescription.text else {
            return
        }
        
        let exercise = ExerciseViewModel(name: name, image: nil, instructions: instructions, reps: nil, time: nil)
        
        delegate.saveNew(exercise)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func repsStepperChanged(repStepper: UIStepper) {
        numberOfReps.text = "\(Int(repStepper.value))"
    }
    @IBAction func timeStepperChanged(timeStepper: UIStepper) {
        if (timeStepper.value <= 30) {
            timeStepper.stepValue = 30
            time.text = "\(Int(timeStepper.value)) sec"
        } else {
            timeStepper.stepValue = 60
            
            let minutes = floor(timeStepper.value/60)
            let seconds = round(timeStepper.value - minutes * 60)
            
            if (seconds <= 0) {
                time.text = "\(Int(minutes)) min"
            } else {
                time.text = "\(Int(minutes)) min \(Int(seconds)) sec"
            }
        }
    }
    @IBAction func addPhotoButtonPressed(sender: AnyObject) {
        
    }
}
