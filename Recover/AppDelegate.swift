	//
//  AppDelegate.swift
//  Recover
//
//  Created by Ryan on 8/11/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var managedObjectContext: NSManagedObjectContext!

    func application(application: UIApplication,didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupAppearance()
        
        // Setup CoreData
        let coreDataManager = CoreDataManager(xcDataModelFileName: "Model", storeType: .SQLite)
        self.managedObjectContext = coreDataManager.managedObjectContext
        checkIfUserHasASavedList()
        
        // Pass the NSManagedObjectContext to the first ViewController
        passContextToExerciseCatalog(fromCoreDataManager: coreDataManager)
        passContextToSavedExercises(fromCoreDataManager: coreDataManager)
        return true
    }
    
    func setupAppearance() {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().barTintColor = UIColor.customGreen()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor.customGreen()
        if let font = UIFont(name: "Avenir-Heavy", size: 18) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        UIButton.appearanceWhenContainedInInstancesOfClasses([BasicTableViewController.self]).tintColor = UIColor.customGreen()
        UIButton.appearanceWhenContainedInInstancesOfClasses([SettingsTableViewController.self]).tintColor = UIColor.customGreen()
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UIToolbar.self]).tintColor = UIColor.customGreen()
        UIButton.appearanceWhenContainedInInstancesOfClasses([UIToolbar.self]).tintColor = UIColor.customGreen()
        UIToolbar.appearance().tintColor = UIColor.customGreen()
        UIStepper.appearance().tintColor = UIColor.customGreen()
    }
    
    func passContextToExerciseCatalog(fromCoreDataManager coreDataManager: CoreDataManager) {
        let tabBarController = self.window?.rootViewController as! UITabBarController
        let navigationViewController = tabBarController.viewControllers!.first as! UINavigationController
        let bodyPartCategoryTableViewController = navigationViewController.viewControllers.first as! BodyPartCategoryTableViewController
        bodyPartCategoryTableViewController.coreDataManager = coreDataManager
        bodyPartCategoryTableViewController.managedObjectContext = coreDataManager.managedObjectContext

    }
    
    func passContextToSavedExercises(fromCoreDataManager coreDataManager: CoreDataManager) {
        let tabBarController = self.window?.rootViewController as! UITabBarController
        let navigationViewController = tabBarController.viewControllers![1] as! UINavigationController
        let savedExerciseTableViewController = navigationViewController.viewControllers.first as! SavedExerciseListTableViewController
        savedExerciseTableViewController.coreDataManager = coreDataManager
        savedExerciseTableViewController.managedObjectContext = coreDataManager.managedObjectContext
    }
    
    // MARK: - Core Data - 

    func checkIfUserHasASavedList() {
        fetchSavedExerciseList()
    }
    
    func fetchSavedExerciseList() {
        let fetchRequest = NSFetchRequest(entityName: "SavedExerciseList")
        
        do {
            guard let savedExerciseLists = try managedObjectContext.executeFetchRequest(fetchRequest) as? [SavedExerciseList] else {
                print("Could not cast object from CoreData as an Array<SavedExerciseList>, creating a new one")
                return
            }
            if (savedExerciseLists == []) {
                createNewSavedExerciseList(withName: "My Exercise List")
            }
            
        } catch {
            fatalError("Failed to fetch User's Saved Exercise List: \(error)")
        }
    }
    
    func createNewSavedExerciseList(withName name: String) {
        guard let savedExerciseList = NSEntityDescription.insertNewObjectForEntityForName("SavedExerciseList", inManagedObjectContext: self.managedObjectContext) as? SavedExerciseList else {
            print("Could not cast NSManagedObject as SavedExerciseList")
            return
        }
        savedExerciseList.setValue(name, forKey: "name")
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to save new SavedExerciseList entity")
            return
        }

    }
    
    // MARK - Application Lifecycle -

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

