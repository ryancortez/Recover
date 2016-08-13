//
//  ExerciseListTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/12/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class ExerciseListTableViewController: BasicTableViewController {

    // MARK: - Initial Setup
    override func viewDidLoad() {
        let navBarTitle = "Body Part"
        self.title = navBarTitle
    }
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatalogExerciseCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Body Part"
        return cell
    }

}
