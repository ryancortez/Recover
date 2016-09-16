//
//  ExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailTableViewController: AdjustableTableViewController, EditExerciseTableViewControllerDelegate, AddToSavedExerciseListTableViewCellDelegate {
    
    var bodyPart: BodyPart!
    var exercise: Exercise!
    var hideImageCell = false
    var hideRepsandTimeCell = false
    var hideInstructionCell = false
    var hideReps = false
    var hideTime = false
    var hideSets = false
    
    // MARK: - Outlets -
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBOutlet weak var titleCell: TitleTableViewCell!
    @IBOutlet weak var imageCell: ImageTableViewCell!
    @IBOutlet weak var repsAndTimeCell: RepAndTimeTableViewCell!
    @IBOutlet weak var instructionsCell: InstructionTableViewCell!
    @IBOutlet weak var addToSavedExerciseListCell: AddToSavedExerciseListTableViewCell!
    
    // MARK: - Initial Setup -
    
    override func viewDidLoad() {
        setupUI()
    }
    func setupUI() {
        setupNavBar()
        setupTableView()
        setupImageView()
    }
    func setupNavBar() {
        self.title = ""
    }
    override func setupTableView() {
        super.setupTableView()
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        tableView.estimatedRowHeight = 44
        setupAddToSavedListCell()
        refreshTableViewData()
    }
    func setupImageView() {
//        imageView.layer.cornerRadius = 20.0
//        imageView.layer.masksToBounds = true
    }
    func refreshTableViewData() {
        tableView.beginUpdates()
        unhideCells()
        setTitle()
        setReps()
        setTime()
        setSets()
        if (hideReps && hideSets && hideTime) {
            hideRepsandTimeCell = true
        }
        setInstuctions()
        setImage()
        tableView.endUpdates()
        tableView.updateConstraints()
    }
    
    func unhideCells() {
        hideRepsandTimeCell = false
        hideTime = false
        hideSets = false
        hideReps = false
        hideInstructionCell = false
        hideImageCell = false
    }
    
    // MARK: Refreshing Table View Data
    func setTitle() {
        if (exerciseTitle != nil) {
            exerciseTitle.text = exercise.name
        }
    }
    func setReps() {
        if (exercise.reps == 0) {
            hideReps = true
            repLabel.text = "--"
        } else {
            repLabel.text = "\(exercise.reps)"
        }
    }
    func setTime() {
        if (exercise.time >= 60) {
            timeLabel.text = "\(exercise.time / 60) min"
        } else {
            if (exercise.time == 0) {
                hideTime = true
                timeLabel.text = "--"
            } else {
                timeLabel.text = "\(exercise.time) sec"
            }
        }
    }
    func setSets() {
        if (exercise.sets == 0) {
            hideSets = true
            setsLabel.text = "--"
        } else {
            setsLabel.text = "\(exercise.sets)"
        }
    }
    func setInstuctions() {
        if (exercise.instructions != "") {
            instructionsLabel.text = "\(exercise.instructions)"
        } else {
            hideInstructionCell = true
        }
    }
    func setImage() {
        imageView.image = nil
        guard let image = UIImage(data: exercise.image) else {
            hideImageCell = true
            return
        }
        imageView.image = image
    }
    
    func setupAddToSavedListCell() {
        if (addToSavedExerciseListCell != nil) {
            addToSavedExerciseListCell.delegate = self
        }
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
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", "My Exercise List")
        let sortDescriptors = [NSSortDescriptor(key: sortingKey, ascending: false)]
        let fetchRequest = getFetchRequest(withEntityName: entityName, withSortDescriptors: sortDescriptors, andPredicate: predicate)
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 0 && hideImageCell) {
            return 0
        }
        if (indexPath.row == 2 && hideRepsandTimeCell) {
            return 0
        }
        if (indexPath.row == 4 && hideInstructionCell) {
            return 0
        }
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: - TableView Cell Delegates -
    
    // MARK: AddToSavedExerciseListTableViewCell Delegate
    func addToSavedExerciseListButtonPressed() {
        let savedExerciseLists = fetchSavedExerciseLists()
        let saveExerciseList = savedExerciseLists?.first
        guard let exerciseCopy = NSEntityDescription.insertNewObjectForEntityForName("Exercise", inManagedObjectContext: self.managedObjectContext) as? Exercise else {
            print("Could not insert new exercise into CoreData"); return
        }
        exerciseCopy.name = exercise.name
        exerciseCopy.image = exercise.image
        exerciseCopy.reps = exercise.reps
        exerciseCopy.time = exercise.time
        exerciseCopy.instructions = exercise.instructions
        
        saveExerciseList?.exercises.insert(exerciseCopy)
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
