//
//  BodyPartCategoryTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class BodyPartCategoryTableViewController: BasicTableViewController, NSFetchedResultsControllerDelegate, AddExerciseTableViewControllerDelegate {
    
    // MARK: - Global Variables
    var managedObjectContext: NSManagedObjectContext!
    var coreDataManager: CoreDataManager!
    var fetchResultsController: NSFetchedResultsController!
    var exercises = [AnyObject]()
    
    // MARK: - Inital Setup
    override func viewDidLoad() {
        
    }
    
    // MARK: - Core Data
    func requestExercisesFromFetchResultsController() {
        let entityName = "Exercise"
        let sortingKey = "name"
        guard let objects = fetchEntityObjectsUsingFetchResultsController(withEntityName: entityName, sortBy: sortingKey, inAscendingOrder: false) else {
            print("Unable to get objects of entity name \(entityName) with sortingKey \(sortingKey)"); return
        }
        exercises = objects
    }
    
    func fetchEntityObjectsUsingFetchResultsController(withEntityName entityName: String, sortBy sortKey:String, inAscendingOrder isAscendingOrder: Bool) -> [AnyObject]? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // Diary Entries will be display in descending order from the date created
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
    
    func saveNew(exercise: Exercise) {
        print("Saving new exercise was fired!")
        let diaryEntry = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: self.managedObjectContext)
        diaryEntry.setValue(title, forKey: "name")
        diaryEntry.setValue(entry, forKey: "reps")
        diaryEntry.setValue(date, forKey: "time")
        diaryEntry.setValue(date, forKey: "instruction")
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to save new diary entry from addButtonPress")
            return
        }

    }
    
    func setupIntialExerciseDatabase() {
    
    }
    
    func fetchUsersExerciseDatabase() {
        
    }
    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Body Part"
        return cell
    }

}
