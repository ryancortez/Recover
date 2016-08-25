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
        setupTabBar()
        checkIfAppHasLaunchedBefore()
        refreshTableView()
    }
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    func setupTabBar() {
        guard let image = UIImage(contentsOfFile: "Catalog") else {
            return
        }
        self.tabBarController!.tabBarItem.image = scale(image, toSize: CGSizeMake(30, 30))
    }
    func checkIfAppHasLaunchedBefore() {
        if (!NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedBefore")) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedBefore")
            NSUserDefaults.standardUserDefaults().synchronize()
            fetchAllExercisesFromRemoteDataBase()
        }
    }
    
    func scale(image: UIImage, toSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRectMake(0,0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - Fetch from Remote Database -
    func fetchAllExercisesFromRemoteDataBase() {
        
        let string = "http://ryancortez.com/RecoverExercises.json"
        guard let url = NSURL(string: string) else {
            print("\(string) is not a valid URL")
            return
        }
        guard let data = NSData(contentsOfURL: url) else {
            print("Could not recreate NSData object from url: \(string)")
            return
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            guard let jsonDictionary = json as? Dictionary<String, AnyObject> else {
                print("Count not create Dictionary<String, AnyObject> by performing JSON serialization of the NSData object")
                return
            }
            print(jsonDictionary)
            guard let categoriesDictionary = jsonDictionary["Categories"] as? Dictionary<String, AnyObject> else {
                return
            }
            
            for key in categoriesDictionary.keys {
                guard let categoryDictionary = categoriesDictionary[key] as? Dictionary<String, AnyObject> else {
                    return
                }
                let categoryName = key
                guard let bodyPart = save(bodyPartWithName: categoryName) else {
                    return
                }
                
                for key in categoryDictionary.keys {
                    guard let exerciseDictionary = categoryDictionary[key] as? Dictionary<String, AnyObject> else {
                        return
                    }
                    let exerciseName = key
                    let exerciseViewModel = ExerciseViewModel(name: exerciseName, image: nil, instructions: nil, bodyPart: bodyPart, reps: nil, time: nil)
                    
                    for key in exerciseDictionary.keys {
                        if let exercisePropertyValue = exerciseDictionary[key] as? String {
                            if (key == "image") {
                                if let url = NSURL(string: exercisePropertyValue) {
                                    if let data = NSData(contentsOfURL: url) {
                                        let image = UIImage(data: data)
                                        exerciseViewModel.image = image
                                    }
                                }
                            }
                            if (key == "instructions") {
                                exerciseViewModel.instructions = exercisePropertyValue
                            }
                            if (key == "reps") {
                                if let value = Int16(exercisePropertyValue) {
                                    exerciseViewModel.reps = value
                                }
                            }
                            if (key == "time") {
                                if let value = Int16(exercisePropertyValue) {
                                    exerciseViewModel.time = value
                                }
                            }
                        }
                    }
                    saveNew(exerciseViewModel)
                }
            }
            
        } catch {
            print("Could not retrieve JSON from remote")
            return
        }
    }
    
    // MARK: - CoreData -
    
    // MARK: Save to CoreData
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