//
//  EditExerciseTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

protocol EditExerciseTableViewControllerDelegate {
    func saveNew(exercise: ExerciseViewModel)
    func edit(currentExercise currentExercise: Exercise, withNewExerciseData newExerciseData: ExerciseViewModel)
}

class EditExerciseTableViewController: BasicTableViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Global Variables
    var bodyPart: BodyPart!
    var exercise: Exercise!
    var delegate: EditExerciseTableViewControllerDelegate!
    var isFirstTimeExerciseDescriptionIsBeginningEditing: Bool  = true
    let imagePicker = UIImagePickerController()
    
    // MARK: - Outlets
    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var exerciseInstructions: UITextView!
    @IBOutlet weak var bodyPartTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var numberOfReps: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    @IBOutlet weak var repStepper: UIStepper!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberOfSets: UILabel!
    
    // MARK: - Inital Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        setupNavBar()
        setupTitle()
        setupInstructions()
        setupSteppers()
        setupBodyPartTextField()
        setupImagePicker()
    }
    func setupNavBar() {
        if (exercise != nil) {
            self.title = "Edit " + "\"\(exercise.name)\""
        } else {
            self.title = "Add Exercise"
        }
    }
    func setupTitle() {
        exerciseTitle.delegate = self
        if (exercise != nil) {
            exerciseTitle.text = exercise.name
        }
    }
    func setupInstructions() {
        exerciseInstructions.delegate = self
        if (exercise != nil) {
            exerciseInstructions.textColor = UIColor.blackColor()
            exerciseInstructions.text = exercise.instructions
        }
    }
    func setupBodyPartTextField() {
        bodyPartTextField.delegate = self
        if (bodyPart != nil) {
            bodyPartTextField.text = bodyPart.name
            bodyPartTextField.enabled = false
        }
    }
    func setupSteppers() {
        setupTimeStepper()
        setupRepStepper()
    }
    func setupTimeStepper() {
        timeStepper.maximumValue = 6000
        timeStepper.minimumValue = 0.0
        
        if (exercise != nil) {
            if (exercise.time == 0) {
                timeStepper.value = 0
                exerciseTime.text = "0 sec"
            } else {
                timeStepper.value = Double(exercise.time)
            }
        }
        
        if (timeStepper.value == 0) {
            timeStepper.stepValue = 30
        }
    }
    func setupRepStepper() {
        repStepper.maximumValue = 99

        if (exercise != nil) {
            if (exercise.reps == 0) {
                repStepper.value = 0
                numberOfReps.text = "--"
            } else {
                repStepper.value = Double(exercise.reps)
            }
        }
    }
    func setupSetsStepper() {
        setsStepper.maximumValue = 99
        
        if (exercise != nil) {
            if (exercise.sets == 0) {
               setsStepper.value = 0
                numberOfReps.text = "--"
            }
        }
    }
    func setupImageView() {
        if (exercise != nil) {
            guard let image = UIImage.init(data: exercise.image) else {
                return
            }
            imageView.image = image
        }
    }
    func setupImagePicker() {
        imagePicker.delegate = self
    }
    
    // MARK: - CoreData -
    func pass(exerciseViewModelToCoreData exerciseViewModel: ExerciseViewModel) {
        if (exercise == nil) {
            delegate.saveNew(exerciseViewModel)
        } else {
            delegate.edit(currentExercise:exercise, withNewExerciseData: exerciseViewModel)
        }
    }
    func fetchMiscBodyPart() -> BodyPart {
        guard let miscBodyPart = fetch(bodyPartWithName: "Miscellaneous") else {
            return saveNewMiscBodyPart()!
        }
        return miscBodyPart
    }
    func saveNewMiscBodyPart() -> BodyPart? {
        guard let miscBodyPart = saveNew(bodyPartWithName: "Miscellaneous") else {
            print("Could not save new \"Miscellaneous\" BodyPart")
            return nil
        }
        return miscBodyPart
    }
    
    // MARK: - TextView Delegate -
    func textViewDidBeginEditing(textView: UITextView) {
        if isFirstTimeExerciseDescriptionIsBeginningEditing {
            isFirstTimeExerciseDescriptionIsBeginningEditing = false
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - Textfield Delegate - 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == exerciseTitle) {
            bodyPartTextField.becomeFirstResponder()
        }
        if (textField == bodyPartTextField) {
            exerciseInstructions.becomeFirstResponder()
        }
        return false
    }
    
    // MARK: - Image Picker Delegate -
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        addPhotoButton.tintColor = UIColor.clearColor()
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        resignFirstResponderFromAllFieldsAndViews()
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        resignFirstResponderFromAllFieldsAndViews()
        
        var name: String
        var instructions: String?
        var reps: Int16?
        var sets: Int16?
        var time: Int16?
        var image: UIImage?
        
        guard let nameString = exerciseTitle.text else { return }
        
        name = nameString
        instructions = exerciseInstructions.text
        reps = Int16(repStepper.value)
        sets = Int16(setsStepper.value)
        time = Int16(timeStepper.value)
        image = imageView.image
        
        guard let bodyPartName = bodyPartTextField.text else {
            print("Did not recieve any associated body part, fetching/creating misc BodyPart")
            let miscBodyPart = fetchMiscBodyPart()
            let exerciseViewModel = ExerciseViewModel(name: name, image: image, instructions: instructions, bodyPart: miscBodyPart, reps: reps, sets: sets, time: time)
            pass(exerciseViewModelToCoreData: exerciseViewModel)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if (bodyPartName == "") {
            let miscBodyPart = fetchMiscBodyPart()
            let exerciseViewModel = ExerciseViewModel(name: name, image: image, instructions: instructions, bodyPart: miscBodyPart, reps: reps, sets: sets, time: time)
            pass(exerciseViewModelToCoreData: exerciseViewModel)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        guard let fetchedBodyPart = fetch(bodyPartWithName: bodyPartName) else {
            guard let newBodyPart = saveNew(bodyPartWithName: bodyPartName) else {
                print("Creating newBodyPart (\(bodyPartName)) did not succeed")
                return
            }
            let exerciseViewModel = ExerciseViewModel(name: name, image: image, instructions: instructions, bodyPart: newBodyPart, reps: reps, sets: sets, time: time)
            pass(exerciseViewModelToCoreData: exerciseViewModel)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        let exerciseViewModel = ExerciseViewModel(name: name, image: image, instructions: instructions, bodyPart: fetchedBodyPart, reps: reps, sets: sets, time: time)
        pass(exerciseViewModelToCoreData: exerciseViewModel)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func repStepperPressed(sender: AnyObject) {
        numberOfReps.text = "\(Int(repStepper.value))"
    }
    @IBAction func setsStepperPressed(sender: AnyObject) {
        numberOfSets.text = "\(Int(setsStepper.value))"
    }
    @IBAction func timeStepperPressed(sender: AnyObject) {
        
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
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Switching Views
    func resignFirstResponderFromAllFieldsAndViews() {
        exerciseTitle.resignFirstResponder()
        exerciseInstructions.resignFirstResponder()
    }
}
