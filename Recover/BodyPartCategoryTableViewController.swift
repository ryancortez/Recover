//
//  BodyPartCategoryTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class BodyPartCategoryTableViewController: BasicTableViewController, EditExerciseTableViewControllerDelegate {
    
    var bodyParts: Array<BodyPart> = []
    
    // MARK: - Inital View Setup - 
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        fetchExerciseData()
    }
    
    // MARK: - CoreData -
    
    // MARK: Saving to CoreData
    func saveNew(exercise: ExerciseViewModel) {
        guard let newExercise = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: self.managedObjectContext) as? Exercise else {
            print("Could not insert new exercise into CoreData"); return
        }
        newExercise.setValue(exercise.name, forKey: "name")
        newExercise.setValue(exercise.reps as! AnyObject?, forKey: "reps")
        newExercise.setValue(exercise.time as! AnyObject?, forKey: "time")
        newExercise.setValue(exercise.instructions, forKey: "instructions")
        
        let bodyPart = exercise.bodyPart
        bodyPart.exercises.insert(newExercise)
        
        saveToCoreData()
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
        let bodyPart = newExerciseData.bodyPart
        bodyPart.exercises.insert(currentExercise)
        
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
    
    // MARK: Fetch from CoreData
    func fetchExerciseData() {
        requestExercisesFromFetchResultsController()
    }
    func requestExercisesFromFetchResultsController() {
        let entityName = "BodyPart"
        let sortingKey = "name"
        guard let objects = fetchEntityObjectsUsingFetchResultsController(withEntityName: entityName, sortBy: sortingKey, inAscendingOrder: false) as? Array<BodyPart> else {
            print("Unable to get objects of entity name \(entityName) with sortingKey \(sortingKey)"); return
        }
        bodyParts = objects
        tableView.reloadData()
    }
    
    // MARK: - TableView -
    
    // MARK: TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyParts.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = bodyParts[indexPath.row].name
        return cell
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let exerciseListSegue = "bodyPartToExerciseList"
        if (segue.identifier == exerciseListSegue) {
            guard let destinationViewController = segue.destinationViewController as? ExerciseListTableViewController else {
                print("Did not find ExerciseListTableViewController in segue.desintationViewControllerf for segue (\(exerciseListSegue))"); return
            }
            destinationViewController.coreDataManager = self.coreDataManager
            destinationViewController.fetchResultsController = self.fetchResultsController
            destinationViewController.managedObjectContext = self.managedObjectContext
            guard let row = tableView.indexPathForSelectedRow?.row else {
                print("Did not find a selected cell"); return
            }
            destinationViewController.bodyPart = bodyParts[row]
        }
        
        let addExerciseSegue = "bodyPartListToAdd"
        if (segue.identifier == addExerciseSegue) {
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
}