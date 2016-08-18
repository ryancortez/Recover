//
//  ExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailTableViewController: BasicTableViewController, EditExerciseTableViewControllerDelegate {
    
    var exercise: Exercise!
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        setupUI()
    }
    func setupUI() {
        setupNavBar()
        setupTableView()
    }
    func setupNavBar() {
        let navBarTitle = "Selected Exercise"
        self.title = navBarTitle
    }
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
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
    
    // MARK: - TableView
    
    // MARK: TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if (exercise.reps != 0 || exercise.time != 0) {
            count += 1
        }
        if (exercise.instructions != "") {
            count += 1
        }
        return count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = createTitleCell(withIndexPath: indexPath)
            return cell
        case 1:
            if (exercise.reps != 0 || exercise.time != 0) {
               let cell = createRepsAndTimeLabelCell(withIndexPath: indexPath)
                return cell
            }
            else if (exercise.instructions != "") {
               let cell = createInstructionCell(withIndexPath: indexPath)
                return cell
            } else {
               return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: TableView Helper Methods
    func createTitleCell(withIndexPath indexPath: NSIndexPath)  -> UITableViewCell{
        let titleCellID = "TitleCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(titleCellID, forIndexPath: indexPath) as? TitleTableViewCell else {
            print("Did not find a TitleTableViewCell when using identifier \(titleCellID)")
            return UITableViewCell()
        }
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.exerciseTitle.text = exercise.name
        return cell
    }
    func createRepsAndTimeLabelCell(withIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repsAndTimeCellID = "RepsAndTimeCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(repsAndTimeCellID, forIndexPath: indexPath) as? RepAndTimeTableViewCell else {
            print("Did not find a TitleTableViewCell when using identifier \(repsAndTimeCellID)")
            return UITableViewCell()
        }
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.repsCounts.text = "\(exercise.reps)"
        cell.timeLabel.text = "\(exercise.time)"
        return cell
    }
    func createInstructionCell(withIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repsAndTimeCellID = "InstructionsCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(repsAndTimeCellID, forIndexPath: indexPath) as? InstructionTableViewCell else {
            print("Did not find a TitleTableViewCell when using identifier \(repsAndTimeCellID)")
            return UITableViewCell()
        }
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.instructionLabel.text = exercise.instructions
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editExerciseID = "editExercise"
        if (segue.identifier == editExerciseID) {
            guard let navigationViewController = segue.destinationViewController as? UINavigationController else {
                print("Did not find UINavigationController when peforming segue (\(editExerciseID))"); return
            }
            guard let destinationViewController = navigationViewController.viewControllers.first as? EditExerciseTableViewController else {
                print("Did not find EditExerciseTableViewController when peforming segue (\(editExerciseID))"); return
            }
            destinationViewController.exercise = self.exercise
            destinationViewController.delegate = self
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
    }

}
