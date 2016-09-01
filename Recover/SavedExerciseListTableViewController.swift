//
//  SavedExerciseListTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class SavedExerciseListTableViewController: AdjustableTableViewController, SavedExerciseDetailTableViewControllerDelegate {
    
    // MARK: - Global Variables
    var sessionIsActive: Bool = false
    var sessionIsPaused: Bool = false
    var savedExerciseList: SavedExerciseList!
    
    // MARK: - Outlet
    @IBOutlet weak var previousExerciseButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var nextExerciseButton: UIBarButtonItem!
    @IBOutlet weak var reorderButton: UIBarButtonItem!
    
    // MARK: - Inital Setup -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonStates()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let name = "My Exercise List"
        guard let savedExerciseList = fetchSavedExerciseList(withName: name) else {
            print("Did not find SavedExerciseList of the name (\(name)")
            return
        }
        fetchExercises(fromSavedExercise: savedExerciseList)
    }
    func setButtonStates() {
        setPreviousExerciseButtonState()
        setStartButtonState()
        setNextExerciseButtonState()
    }
    func setPreviousExerciseButtonState() {
        if sessionIsActive {
            previousExerciseButton.enabled = true
            previousExerciseButton.tintColor = nil
        } else {
            previousExerciseButton.enabled = false
            previousExerciseButton.tintColor = UIColor.clearColor()
        }
    }
    func setStartButtonState() {
        if sessionIsActive {
            if sessionIsPaused {
                startButton.title = "Resume"
            } else {
                startButton.title = "Pause"
            }
        } else {
            startButton.title = "Start Session"
        }
    }
    func setNextExerciseButtonState() {
        if sessionIsActive {
            nextExerciseButton.enabled      = true
            nextExerciseButton.tintColor    = nil
        }else{
            nextExerciseButton.enabled      = false
            nextExerciseButton.tintColor    = UIColor.clearColor()
        }
    }

    // MARK: - Exercise Session Logic -
    
    func resumeExerciseSession() {
        sessionIsPaused = false
        setButtonStates()
    }
    func pauseExerciseSession() {
        sessionIsPaused = true
        setButtonStates()
    }
    func startExerciseSession() {
        if (tableView.visibleCells != []) {
            sessionIsActive = true
            setButtonStates()
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
            performSegueWithIdentifier("startSession" , sender: self)
        }
    }
    
    // MARK: - Core Data -
    
    // MARK: Fetch from Core Data
    func fetchSavedExerciseList(withName name: String) -> SavedExerciseList? {
        let entityName = "SavedExerciseList"
        let sortingKey = "name"
        let sortDescriptors = [NSSortDescriptor(key: sortingKey, ascending: true)]
        let predicate = NSPredicate(format: "name contains %@", argumentArray: [name])
        let fetchRequest = getFetchRequest(withEntityName: entityName, withSortDescriptors: sortDescriptors, andPredicate: predicate)
        guard let objects = getObjects(withFetchRequest: fetchRequest) else {
            print("Did not recieve any objects from fetchRequest")
            return nil
        }
        guard let object = objects.first else {
            print("Found no SavedExerciseList matching name: \(name)")
            return nil
        }
        guard let savedExerciseList = object as? SavedExerciseList else {
            print("Could not cast the object pulled from entity (\(entityName) with name (\(name) CoreData")
            return nil
        }
        return savedExerciseList
    }
    func fetchExercises(fromSavedExercise savedExerciseList: SavedExerciseList) {
        exercises = Array(savedExerciseList.exercises)
        tableView.reloadData()
    }
    
    // MARK: - TableView -
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    // MARK: TableView Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SavedExerciseCell", forIndexPath: indexPath) as? SavedExerciseTableViewCell else {
            print("Could not create SavedExerciseTableViewCell")
            return tableView.dequeueReusableCellWithIdentifier("SavedExerciseCell", forIndexPath: indexPath)
        }
        let exercise = exercises[indexPath.row]
        cell.exerciseName.text = exercise.name
        cell.selectionStyle = .None
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            
            let exercise = exercises[indexPath.row]
            managedObjectContext.deleteObject(exercise)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Unable to save Core Data state")
                return
            }
            exercises.removeAtIndex(indexPath.row)
             tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
        if (editingStyle == .Insert) {
            
        }
    }
    
    // MARK: TableView Delegate
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let exercise = exercises[sourceIndexPath.row]
        exercises.removeAtIndex(sourceIndexPath.row)
        exercises.insert(exercise, atIndex: destinationIndexPath.row)
    }
    
    // MARK: SavedExerciseDetail Delegate
    func stopButtonWasPressed() {
        sessionIsActive = false
        setButtonStates()
    }
    
    // MARK: - Actions
    @IBAction func reorderButtonPressed(sender: AnyObject) {
        if tableView.editing {
            reorderButton.title = "Edit"
            reorderButton.style = .Plain
            tableView.setEditing(false, animated: true)
        } else {
            reorderButton.title = "Done"
            reorderButton.style = .Done
            tableView.setEditing(true, animated: true)
            
        }
    }
    @IBAction func previousExerciseButtonPressed(sender: AnyObject) {
    }
    @IBAction func startButtonPressed(sender: AnyObject) {
        if sessionIsActive {
            if sessionIsPaused {
                resumeExerciseSession()
            } else {
                pauseExerciseSession()
            }
        } else {
            startExerciseSession()
        }
    }
    @IBAction func nextExerciseButtonPressed(sender: AnyObject) {
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "savedListToDetail" || segue.identifier ==  "startSession") {
            
            guard let navigationController = segue.destinationViewController as? UINavigationController else {
                fatalError("Did not find NavigationController in segue.destinationViewController")
            }
            guard let destination = navigationController.viewControllers.first as? SavedExerciseDetailTableViewController else {
                fatalError("Did not find SavedExerciseDetailTableViewController in segue.destinationViewController")
            }
            destination.sessionIsActive = self.sessionIsActive
            destination.sessionIsPaused = self.sessionIsPaused
            destination.exerciseIndex = tableView.indexPathForSelectedRow?.row
            destination.exercises = self.exercises
            destination.exercise = self.exercises[(tableView.indexPathForSelectedRow?.row)!]
            destination.delegate = self
        }
    }

}
