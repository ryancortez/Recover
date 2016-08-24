//
//  BasicTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class BasicTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {
    
    // MARK: - Global Variables -
    let mainStoryboardName = "Main"
    var coreDataManager: CoreDataManager!
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController!
    var exercises = [Exercise]()
    
    // MARK: - Core Data - 
    
    // MARK: Save to CoreData
    
    func saveNew(exercise: ExerciseViewModel) {        
        guard let newExercise = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: self.managedObjectContext) as? Exercise else {
            print("Could not insert new exercise into CoreData"); return
        }
        
        newExercise.setValue(exercise.name, forKey: "name")
        newExercise.setValue(exercise.instructions, forKey: "instructions")
        
        if (exercise.instructions != nil) {
            newExercise.setValue(NSInteger(exercise.time!), forKey: "time")
        }
        if (exercise.reps != nil) {
            newExercise.setValue(NSInteger(exercise.reps!), forKey: "reps")
        }
        
        guard let image = exercise.image else {
            let bodyPart = exercise.bodyPart
            bodyPart.exercises.insert(newExercise)
            saveCoreDataState()
            return
        }
        let imageData = UIImageJPEGRepresentation(image, 1)
        newExercise.setValue(imageData, forKey: "image")
        
        let bodyPart = exercise.bodyPart
        bodyPart.exercises.insert(newExercise)
        saveCoreDataState()
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
        
        saveCoreDataState()
        tableView.reloadData()
    }
    
    func saveCoreDataState() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to edit exercise entry")
            return
        }
    }
    
    
    // MARK: Fetch from Core Data 
    
    
    func getFetchRequest(withEntityName entityName: String, withSortDescriptors sortDescriptiors: Array<NSSortDescriptor>?, andPredicate predicate: NSPredicate?) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptiors
        fetchRequest.predicate = predicate
    
        return fetchRequest
    }
    func getObjects(withFetchRequest fetchRequest: NSFetchRequest) -> Array<AnyObject>? {
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("fetchResultsController was unable to perform fetch")
            return nil
        }
        guard let fetchedObjects = fetchResultsController.fetchedObjects else {
            print ("Unable to fetch objects from \(fetchRequest.entityName)")
            return nil
        }
        
        return fetchedObjects
    }
    
    func fetchEntityObjectsUsingFetchResultsController(withEntityName entityName: String, sortBy sortKey:String, inAscendingOrder isAscendingOrder: Bool) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: isAscendingOrder)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("fetchResultsController was unable to perform fetch")
            return nil
        }
        guard let fetchedObjects = fetchResultsController.fetchedObjects else {
            print ("Unable to fetch objects from Entity: \(entityName)")
            return nil
        }
        
        return fetchedObjects
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: Fetch Controller Delegate Protocol
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    // MARK: - Create View Controllers -
    
    func createViewController(inStoryBoard storyboardName: String, withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        return viewController
    }
    
    // MARK: - TableView -
    
    // MARK: TableView Delegate
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
