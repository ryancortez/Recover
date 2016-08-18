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
        exercises = Array(bodyPart.exercises)
        setupInitalUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: Inital UI
    func setupInitalUI() {
        setupNavBar()
    }
    func setupNavBar() {
        let navBarTitle = "Body Part"
        self.title = navBarTitle
        
    }
    
    // MARK: - Core Data -
    
    // MARK: Fetch from Core Data
    func fetchExerciseData() {
        requestExercisesFromFetchResultsController()
    }
    func requestExercisesFromFetchResultsController() {
        let entityName = "Exercise"
        let sortingKey = "name"
        guard let objects = fetchEntityObjectsUsingFetchResultsController(withEntityName: entityName, sortBy: sortingKey, inAscendingOrder: false) else {
            print("Unable to get objects of entity name \(entityName) with sortingKey \(sortingKey)"); return
        }
        exercises = objects
        tableView.reloadData()
    }
    
    func fetchAllExercisesFromBodyPart() {
        let entityName = "BodyPart"
        let sortKey = "name"
        let fetchRequest = NSFetchRequest(entityName: entityName)
         fetchRequest.predicate = NSPredicate(format: "ANY name contains %@", argumentArray: [bodyPart.name])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: false)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("fetchResultsController was unable to perform fetch")
            return
        }
        guard let fetchedObjects = fetchResultsController.fetchedObjects else {
            print ("Unable to fetch objects from Entity: \(entityName)")
            return
        }
        
        exercises = fetchedObjects
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
    
    // MARK: - Segues -
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueToDetail = "exerciseListToDetail"
        if (segue.identifier == segueToDetail) {
            guard let destinationViewController = segue.destinationViewController as? ExerciseDetailTableViewController else {
                print("Did not find ExerciseDetailTableViewController when using segue (\(segueToDetail))"); return
            }
            guard let row = tableView.indexPathForSelectedRow?.row else {
                print("Did not find selected row in tableView.indexPathForSelectedRow?.row"); return
            }
            guard let exercise = exercises[row] as? Exercise else {
                print("Did not find Exercise in exercises[\(row)]")
                print("Found this instead \(exercises[row].description)")
                return
            }
            destinationViewController.exercise = exercise
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
        let exerciseListToAddSegue = "exerciseListToAdd"
        let bodyListToAddSegue = "bodyPartListToAdd"
        if (segue.identifier == exerciseListToAddSegue || segue.identifier == bodyListToAddSegue) {
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
