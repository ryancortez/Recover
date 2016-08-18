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
    var coreDataManager: CoreDataManager!
    var managedObjectContext: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController!
    var exercises = [AnyObject]()

    
    // MARK: - Core Data -
    
    // MARK: Fetch from Core Data 
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
