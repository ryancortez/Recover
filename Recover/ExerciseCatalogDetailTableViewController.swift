//
//  ExerciseCatalogDetailTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/24/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import Foundation
import UIKit

class ExerciseCatalogDetailTableViewController: ExerciseDetailTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupNavBar() {
        super.setupNavBar()
        
    }
    override func setupTableView() {
        super.setupTableView()
        tableView.contentOffset.y = CGFloat(35)
    }
}
