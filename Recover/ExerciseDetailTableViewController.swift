//
//  ExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailTableViewController: BasicTableViewController, EditExerciseTableViewControllerDelegate, AddToSavedExerciseListTableViewCellDelegate {
    
    var bodyPart: BodyPart!
    var exercise: Exercise!
    var image: UIImage?
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        setupUI()
        image = UIImage(data: exercise.image)
    }
    func setupUI() {
        setupNavBar()
        setupTableView()
    }
    func setupNavBar() {
        self.title = ""
    }
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - CoreData - 
    
    // MARK: Saving Exercises to CoreData
    override func saveNew(exercise: ExerciseViewModel) {
        super.saveNew(exercise)
        tableView.reloadData()
    }
    override func edit(currentExercise currentExercise: Exercise, withNewExerciseData newExerciseData: ExerciseViewModel) {
       super.edit(currentExercise: currentExercise, withNewExerciseData: newExerciseData)
        tableView.reloadData()
    }
    
    // MARK: Fetch from CoreData
    
    func fetchSavedExerciseLists() -> [SavedExerciseList]? {
        let entityName = "SavedExerciseList"
        let sortingKey = "name"
        let sortDescriptors = [NSSortDescriptor(key: sortingKey, ascending: false)]
        let fetchRequest = getFetchRequest(withEntityName: entityName, withSortDescriptors: sortDescriptors, andPredicate: nil)
        guard let objects = getObjects(withFetchRequest: fetchRequest) else {
            print("Did not recieve any objects from fetchRequest")
            return nil
        }
        guard let savedExerciseLists = objects as? Array<SavedExerciseList> else {
            print("Could not cast objects as Array<SavedExerciseList>")
            return nil
        }
        return savedExerciseLists
    }
    
    // MARK: - TableView -
    
    // MARK: TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 3
        
        if (image != nil) {
            count += 1
        }
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
                return createImageCell(withIndexPath: indexPath)
        case 1:
            if (image != nil) {
                return createTitleCell(withIndexPath: indexPath)
            } else if (exercise.reps != 0 || exercise.time != 0) {
               return createRepsAndTimeLabelCell(withIndexPath: indexPath)
            } else if (exercise.instructions != "") {
                return createInstructionCell(withIndexPath: indexPath)
            } else {
               return UITableViewCell()
            }
        case 2:
            if (exercise.reps != 0 || exercise.time != 0) {
                return createRepsAndTimeLabelCell(withIndexPath: indexPath)
            } else if (exercise.instructions != "") {
                return createInstructionCell(withIndexPath: indexPath)
            } else {
                return createAddToSavedExerciseListCell(withIndexPath: indexPath)
            }
        case 3:
            if (exercise.instructions != "") {
                return createInstructionCell(withIndexPath: indexPath)
            } else {
                return createAddToSavedExerciseListCell(withIndexPath: indexPath)
            }
        case 4:
            return createAddToSavedExerciseListCell(withIndexPath: indexPath)
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
    func createAddToSavedExerciseListCell(withIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let titleCellID = "AddToSavedExerciseListCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(titleCellID, forIndexPath: indexPath) as? AddToSavedExerciseListTableViewCell else {
            print("Did not find a TitleTableViewCell when using identifier \(titleCellID)")
            return UITableViewCell()
        }
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.delegate = self
        return cell
    }
    func createImageCell(withIndexPath indexPath: NSIndexPath)  -> UITableViewCell{
        let imageCellID = "ImageCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(imageCellID, forIndexPath: indexPath) as? ImageTableViewCell else {
            print("Did not find a TitleTableViewCell when using identifier \(imageCellID)")
            return UITableViewCell()
        }
        cell.selectionStyle = .None
        cell.accessoryType = .None
        let image = UIImage(data: exercise.image)
        cell.exerciseImage.image = image
        return cell
    }

    
    // MARK: - TableView Cell Delegates -
    
    // MARK: AddToSavedExerciseListTableViewCell Delegate
    func addToSavedExerciseListButtonPressed() {
        let savedExerciseLists = fetchSavedExerciseLists()
        let saveExerciseList = savedExerciseLists?.first
        saveExerciseList?.exercises.insert(exercise)
        saveCoreDataState()
    }
    
    // MARK: - Segues -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editExerciseID = "detailToEdit"
        if (segue.identifier == editExerciseID) {
            guard let navigationViewController = segue.destinationViewController as? UINavigationController else {
                print("Did not find UINavigationController when peforming segue (\(editExerciseID))"); return
            }
            guard let destinationViewController = navigationViewController.viewControllers.first as? EditExerciseTableViewController else {
                print("Did not find EditExerciseTableViewController when peforming segue (\(editExerciseID))"); return
            }
            destinationViewController.bodyPart = bodyPart
            destinationViewController.exercise = self.exercise
            destinationViewController.delegate = self
            destinationViewController.managedObjectContext = self.managedObjectContext
        }
    }
}
