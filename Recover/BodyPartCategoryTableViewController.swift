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
        refreshTableView()
    }
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - CoreData -
    override func saveNew(exercise: ExerciseViewModel) {
        super.saveNew(exercise)
        
        refreshTableView()
    }
    
    // MARK: Fetch from CoreData
    func refreshTableView() {
        requestBodyPartsFromFetchResultsController()
    }
    func requestBodyPartsFromFetchResultsController() {
        let entityName = "BodyPart"
        let sortingKey = "name"
        guard let objects = fetchEntityObjectsUsingFetchResultsController(withEntityName: entityName, sortBy: sortingKey, inAscendingOrder: true) as? Array<BodyPart> else {
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
    // MARK: TableView Delegate
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            guard let bodyPart = fetchResultsController.objectAtIndexPath(indexPath) as? NSManagedObject else {
                print("Could not case object found as an NSManagedObject at indexPath: \(indexPath.description)"); return
            }
            managedObjectContext.deleteObject(bodyPart)
            saveCoreDataState()
            refreshTableView()
        }
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