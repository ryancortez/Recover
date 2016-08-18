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

class EditExerciseTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Global Variables
    var exercise: Exercise!
    var delegate: EditExerciseTableViewControllerDelegate!
    var isFirstTimeExerciseDescriptionIsBeginningEditing: Bool  = true
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Outlets
    @IBOutlet weak var exerciseTitle: UITextField!
    @IBOutlet weak var exerciseInstructions: UITextView!
    @IBOutlet weak var bodyPart: UITextField!
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
        exerciseInstructions.delegate = self
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
    
    // MARK: - CoreData -
    
    // MARK: Save to CoreData
    func saveNew(bodyPartWithName bodyPartName: String) -> BodyPart? {
        guard let newBodyPart = NSEntityDescription.insertNewObjectForEntityForName("BodyPart", inManagedObjectContext: self.managedObjectContext) as? BodyPart else {
            print("Could not cast fetched object as BodyPart")
            return nil
        }
        newBodyPart.setValue(bodyPartName, forKey: "name")
        
        do {
            try self.managedObjectContext.save()
            return newBodyPart
        } catch {
            print("Unable to save new BodyPart entity")
            return nil
        }
    }
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

    
    // MARK: Fetch from CoreData
    func fetch(bodyPartWithName bodyPartName: String) -> BodyPart? {
        
        var fetchedObjects = []
        let fetchRequest = NSFetchRequest(entityName: "BodyPart")
        fetchRequest.predicate = NSPredicate(format: "ANY name contains %@", argumentArray: [bodyPartName])
        do {
            try fetchedObjects = managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
           print("Did not find any body part matching that name")
        }
        
        if (fetchedObjects.count >= 1) {
            guard let fetchedBodyPart = fetchedObjects.objectAtIndex(0) as? BodyPart else {
                print("Could not create BodyPart from fetched object"); return nil
            }
            return fetchedBodyPart
            
        } else {
            return nil
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
        guard let bodyPartName = bodyPart.text else {
            print("Did not reciece any associated body part, fetching/creating misc BodyPart")
            let miscBodyPart = fetchMiscBodyPart()
            let exerciseViewModel = ExerciseViewModel(name: name, image: nil, instructions: instructions, bodyPart: miscBodyPart, reps: nil, time: nil)
            pass(exerciseViewModelToCoreData: exerciseViewModel)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        guard let fetchedBodyPart = fetch(bodyPartWithName: bodyPartName) else {
            print("Did not find bodyPart, attempting to create BodyPart")
            guard let newBodyPart = saveNew(bodyPartWithName: bodyPartName) else {
                print("Creating newBodyPart (\(bodyPartName)) did not succeed")
                return
            }
            let exerciseViewModel = ExerciseViewModel(name: name, image: nil, instructions: instructions, bodyPart: newBodyPart, reps: nil, time: nil)
            pass(exerciseViewModelToCoreData: exerciseViewModel)
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        let exerciseViewModel = ExerciseViewModel(name: name, image: nil, instructions: instructions, bodyPart: fetchedBodyPart, reps: nil, time: nil)
        pass(exerciseViewModelToCoreData: exerciseViewModel)
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
