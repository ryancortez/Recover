//
//  ExerciseDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class ExerciseDetailTableViewController: BasicTableViewController {
    
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        let navBarTitle = "Selected Exercise"
        self.title = navBarTitle
    }
    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.accessoryType = .None
        cell.textLabel?.text = "Exercise Details"
        return cell
    }
}
