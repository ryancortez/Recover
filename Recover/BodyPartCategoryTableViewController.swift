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
    
    // MARK: - CoreData -
    
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
    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Body Part"
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
        }

    }
}
