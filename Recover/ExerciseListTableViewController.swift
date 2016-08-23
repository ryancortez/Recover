//
//  ExerciseListTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class ExerciseListTableViewController: BasicTableViewController, EditExerciseTableViewControllerDelegate {
    
    var bodyPart: BodyPart!
    
    // MARK: - Initial Setup -
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        requestExercises(fromBodyPart: bodyPart)
        exercises = Array(bodyPart.exercises)
        setupInitalUI()
    }
    override func viewWillAppear(animated: Bool) {
        requestExercises(fromBodyPart: bodyPart)
    }
    
    // MARK: Inital UI
    func setupInitalUI() {
        setupNavBar()
    }
    func setupNavBar() {
        let navBarTitle = bodyPart.name
        self.title = navBarTitle
        
    }
    
    // MARK: - Core Data -
    
    // MARK: Fetch from Core Data
    func requestExercises(fromBodyPart bodyPart: BodyPart) {
        let entityName = "BodyPart"
        let sortingKey = "name"
        let sortDescriptors = [NSSortDescriptor(key: sortingKey, ascending: false)]
        let predicate = NSPredicate(format: "name == %@", bodyPart.name)
        let fetchRequest = getFetchRequest(withEntityName: entityName, withSortDescriptors: sortDescriptors, andPredicate: predicate)
        guard let objects = getObjects(withFetchRequest: fetchRequest) else {
            print("Did not recieve any objects from fetchRequest")
            return
        }
        guard let object = objects.first else {
            exercises = Array(bodyPart.exercises)
            tableView.reloadData()
            return
        }
        let bodyPart = object as! BodyPart
        exercises = Array(bodyPart.exercises)
        tableView.reloadData()
    }
    
    // MARK: Saving to CoreData
    func saveNew(exercise: ExerciseViewModel) {
        
        guard let exerciseEntry = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: self.managedObjectContext) as? Exercise else {
            print("Could not insert new exercise into CoreData"); return
        }
        exerciseEntry.setValue(exercise.name, forKey: "name")
        exerciseEntry.setValue(exercise.reps as! AnyObject?, forKey: "reps")
        exerciseEntry.setValue(exercise.time as! AnyObject?, forKey: "time")
        exerciseEntry.setValue(exercise.instructions, forKey: "instructions")
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to save new exercise entry")
            return
        }
        tableView.reloadData()
    }
    func edit(currentExercise currentExercise: Exercise, withNewExerciseData newExerciseData: ExerciseViewModel) {
        
        currentExercise.name = newExerciseData.name
        
        guard let instructions = newExerciseData.instructions else {
            print("Did not find any instuctions saved in currentExercise")
            return
        }
        currentExercise.instructions = instructions
        
        if let reps = newExerciseData.reps {
            currentExercise.reps = reps
        } else {
            currentExercise.reps = 0
        }
        if let time = newExerciseData.time {
            currentExercise.time = time
        } else {
            currentExercise.time = 0
        }
        saveToCoreData()
        tableView.reloadData()
    }
    func saveToCoreData() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to edit exercise entry")
            return
        }
    }
    
    // MARK: - TableView -
    
    // MARK: TableView Data Source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = exercises[indexPath.row].name
        return cell
    }
    
    // MARK: TableView Delegate
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            guard let exercise = fetchResultsController.objectAtIndexPath(indexPath) as? NSManagedObject else {
                print("Could not case object found as an NSManagedObject at indexPath: \(indexPath.description)"); return
            }
            managedObjectContext.deleteObject(exercise)
            saveToCoreData()
            requestExercises(fromBodyPart: bodyPart)
        }
    }
    
    // MARK: - Segues -
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueToDetail = "exerciseListToDetail"
        if (segue.identifier == segueToDetail) {
            prepareForExerciseDetailSegue(segue)
        }
        let exerciseListToAddSegue = "exerciseListToAdd"
        let bodyListToAddSegue = "bodyPartListToAdd"
        if (segue.identifier == exerciseListToAddSegue || segue.identifier == bodyListToAddSegue) {
            prepareForExerciseEditSegue(segue)
        }
    }
    func prepareForExerciseDetailSegue(segue: UIStoryboardSegue) {
        guard let destinationViewController = segue.destinationViewController as? ExerciseDetailTableViewController else {
            print("Did not find ExerciseDetailTableViewController when using segue (exerciseListToDetail)"); return
        }
        guard let row = tableView.indexPathForSelectedRow?.row else {
            print("Did not find selected row in tableView.indexPathForSelectedRow?.row"); return
        }
        let exercise = exercises[row]
        
        destinationViewController.exercise = exercise
        destinationViewController.bodyPart = bodyPart
        destinationViewController.managedObjectContext = self.managedObjectContext
    }
    func prepareForExerciseEditSegue(segue: UIStoryboardSegue) {
        guard let navigationController = segue.destinationViewController as? UINavigationController else {
            print("Did not find UINavigationController when performing segue (\("bodyPartToAdd"))"); return
        }
        guard let destinationViewController = navigationController.viewControllers.first as? EditExerciseTableViewController  else {
            print("Did not find AddExerciseTableViewController when performing segue (\("bodyPartToAdd"))"); return
        }
        destinationViewController.delegate = self
        destinationViewController.managedObjectContext = self.managedObjectContext
    }
}
